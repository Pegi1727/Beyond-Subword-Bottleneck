#!/usr/bin/env python3
"""Standalone analysis script for Beyond the Subword Bottleneck."""
from pathlib import Path
import argparse, sys, warnings
import numpy as np
import pandas as pd

ROOT = Path(__file__).resolve().parents[2]
METRICS = ["TCR", "TMR", "TCI"]
REQUIRED = ["Language", "Item_ID", *METRICS]
def paths():
    (ROOT / "tables").mkdir(parents=True, exist_ok=True)
    (ROOT / "figures").mkdir(parents=True, exist_ok=True)
def get_input():
    p=argparse.ArgumentParser(description=__doc__)
    p.add_argument("--input", type=Path, default=None, help="CSV input (default: data/final_analysis_dataset.csv)")
    a=p.parse_args()
    candidates=[a.input] if a.input else [ROOT/"data"/"final_analysis_dataset.csv", ROOT/"final_analysis_dataset.csv"]
    for candidate in candidates:
        if candidate and candidate.exists(): return candidate
    raise FileNotFoundError("Input CSV not found. Pass --input PATH or place it at data/final_analysis_dataset.csv")
def load_data():
    path=get_input()
    try: d=pd.read_csv(path)
    except Exception as e: raise RuntimeError(f"Could not read CSV {path}: {e}") from e
    missing=set(REQUIRED)-set(d.columns)
    if missing: raise ValueError(f"Missing required columns: {sorted(missing)}")
    d=d[REQUIRED].copy()
    d["Language"]=d["Language"].astype("string").str.strip()
    d["Item_ID"]=d["Item_ID"].astype("string").str.strip()
    for c in METRICS: d[c]=pd.to_numeric(d[c],errors="coerce")
    d=d.replace([np.inf,-np.inf],np.nan)
    d=d.dropna(subset=REQUIRED)
    d=d[(d.Language!="") & (d.Item_ID!="")]
    if d.empty: raise ValueError("No valid observations remain after validation")
    return d

def pairwise_dunn(d, metric):
    from itertools import combinations
    from scipy.stats import rankdata, norm
    vals=d[metric].to_numpy(float); gr=d.Language.astype(str).to_numpy()
    ranks=rankdata(vals,method="average"); N=len(vals)
    _, counts=np.unique(vals,return_counts=True)
    tie_sum=np.sum(counts**3-counts)
    variance=(N*(N+1)/12) - tie_sum/(12*(N-1)) if N>1 else 0.0
    rows=[]
    for a,b in combinations(sorted(np.unique(gr)),2):
        ia=gr==a; ib=gr==b
        denom=np.sqrt(max(variance,0)*(1/ia.sum()+1/ib.sum()))
        z=(ranks[ia].mean()-ranks[ib].mean())/denom if denom>0 else 0.0
        rows.append({"Metric":metric,"Group1":a,"Group2":b,"N1":int(ia.sum()),"N2":int(ib.sum()),"Z":z,"P_raw":2*norm.sf(abs(z))})
    if rows:
        pvals=[r["P_raw"] for r in rows]
        order=np.argsort(pvals); adj=np.empty(len(pvals)); running=0.0
        for rank,idx in enumerate(order): running=max(running,(len(pvals)-rank)*pvals[idx]); adj[idx]=min(running,1.0)
        for r,pv in zip(rows,adj): r["P_Holm"]=float(pv)
    return rows

def main():
    paths(); import matplotlib
    matplotlib.use("Agg")
    import matplotlib.pyplot as plt
    d=load_data(); order=sorted(d.Language.astype(str).unique())
    fig,ax=plt.subplots(figsize=(8,5.2))
    vals=[d.loc[d.Language.astype(str)==g,"TCI"].to_numpy() for g in order]
    ax.boxplot(vals,tick_labels=order,patch_artist=True,showfliers=False,medianprops={"color":"black","linewidth":1.7},boxprops={"facecolor":"#91c4df","alpha":.8},whiskerprops={"color":"#555555"})
    rng=np.random.default_rng(2025)
    for i,x in enumerate(vals,1): ax.scatter(rng.normal(i,.045,len(x)),x,s=14,alpha=.45,color="#16324f",edgecolors="none",zorder=3)
    ax.set(title="TCI by language",xlabel="Language",ylabel="TCI"); ax.grid(axis="y",alpha=.25); fig.tight_layout()
    out=ROOT/"figures"/"figure3_tci.jpg"; fig.savefig(out,dpi=300,bbox_inches="tight",format="jpeg",pil_kwargs={"quality":95,"subsampling":0}); plt.close(fig)
    print(f"Saved high-resolution JPEG: {out}")
if __name__=="__main__":
    try: main()
    except Exception as e: print(f"ERROR: {e}",file=sys.stderr); sys.exit(1)
