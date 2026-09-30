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
    paths(); from scipy import stats
    d=load_data(); rows=[]
    for m in METRICS:
        for lang,g in d.groupby("Language",sort=True):
            x=g[m].dropna().to_numpy();
            if len(x)>=3 and np.unique(x).size>1:
                try: stat,p=stats.shapiro(x); note=""
                except Exception as e: stat,p=np.nan,np.nan; note=str(e)
            else: stat,p=np.nan,np.nan; note="Shapiro requires >=3 observations and nonconstant data"
            rows.append({"Metric":m,"Test":"Shapiro-Wilk","Language":lang,"N":len(x),"Statistic":stat,"P_value":p,"Note":note})
        groups=[g[m].dropna().to_numpy() for _,g in d.groupby("Language",sort=True)]
        try:
            stat,p=stats.levene(*groups,center="median") if len(groups)>1 else (np.nan,np.nan); note=""
        except Exception as e: stat,p,note=np.nan,np.nan,str(e)
        rows.append({"Metric":m,"Test":"Levene (median-centered)","Language":"ALL_GROUPS","N":sum(map(len,groups)),"Statistic":stat,"P_value":p,"Note":note})
    out=pd.DataFrame(rows); out.to_csv(ROOT/"tables"/"normality_homoscedasticity.csv",index=False)
    print(out.to_string(index=False)); print("Saved tables/normality_homoscedasticity.csv")
if __name__=="__main__":
    try: main()
    except Exception as e: print(f"ERROR: {e}",file=sys.stderr); sys.exit(1)
