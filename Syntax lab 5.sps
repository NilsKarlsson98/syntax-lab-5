* Encoding: UTF-8.

DATASET ACTIVATE DataSet24.
RECODE sex ('female'=0) (ELSE=1) INTO gender.
VARIABLE LABELS  gender 'gender'.
EXECUTE.

MIXED pain_rating WITH age STAI_trait pain_cat cortisol_serum mindfulness gender time
  /CRITERIA=DFMETHOD(SATTERTHWAITE) CIN(95) MXITER(100) MXSTEP(10) SCORING(1) 
    SINGULAR(0.000000000001) HCONVERGE(0, ABSOLUTE) LCONVERGE(0, ABSOLUTE) PCONVERGE(0.000001, ABSOLUTE)    
  /FIXED=age STAI_trait pain_cat cortisol_serum mindfulness gender time | SSTYPE(3)
  /METHOD=REML
  /PRINT=SOLUTION
  /RANDOM=INTERCEPT | SUBJECT(ID) COVTYPE(VC)
  /SAVE=PRED.

MIXED pain_rating WITH age STAI_trait pain_cat cortisol_serum mindfulness gender time
  /CRITERIA=DFMETHOD(SATTERTHWAITE) CIN(95) MXITER(100) MXSTEP(10) SCORING(1) 
    SINGULAR(0.000000000001) HCONVERGE(0, ABSOLUTE) LCONVERGE(0, ABSOLUTE) PCONVERGE(0.000001, ABSOLUTE)    
  /FIXED=age STAI_trait pain_cat cortisol_serum mindfulness gender time | SSTYPE(3)
  /METHOD=REML
  /PRINT=CORB  SOLUTION
  /RANDOM=INTERCEPT time | SUBJECT(ID) COVTYPE(UN)
  /SAVE=PRED.

SORT CASES  BY ID.
SPLIT FILE SEPARATE BY ID.

* Chart Builder.
GGRAPH
  /GRAPHDATASET NAME="graphdataset" VARIABLES=time MEAN(pain_rating)[name="MEAN_pain_rating"] 
    Obs_or_pred MISSING=LISTWISE REPORTMISSING=NO
  /GRAPHSPEC SOURCE=INLINE.
BEGIN GPL
  SOURCE: s=userSource(id("graphdataset"))
  DATA: time=col(source(s), name("time"), unit.category())
  DATA: MEAN_pain_rating=col(source(s), name("MEAN_pain_rating"))
  DATA: Obs_or_pred=col(source(s), name("Obs_or_pred"), unit.category())
  GUIDE: axis(dim(1), label("time"))
  GUIDE: axis(dim(2), label("Mean pain_rating"))
  GUIDE: legend(aesthetic(aesthetic.color.interior), label("Obs_or_pred"))
  GUIDE: text.title(label("Multiple Line Mean of pain_rating by time by Obs_or_pred"))
  SCALE: linear(dim(2), include(0))
  ELEMENT: line(position(time*MEAN_pain_rating), color.interior(Obs_or_pred), missing.wings())
END GPL.

SPLIT FILE OFF.

COMPUTE time_centered=time - 2.5.
EXECUTE.

COMPUTE time_centered_sq=time_centered * time_centered.
EXECUTE.

MIXED pain_rating WITH age STAI_trait pain_cat cortisol_serum mindfulness gender time_centered 
    time_centered_sq
  /CRITERIA=DFMETHOD(SATTERTHWAITE) CIN(95) MXITER(100) MXSTEP(10) SCORING(1) 
    SINGULAR(0.000000000001) HCONVERGE(0, ABSOLUTE) LCONVERGE(0, ABSOLUTE) PCONVERGE(0.000001, ABSOLUTE)    
  /FIXED=age STAI_trait pain_cat cortisol_serum mindfulness gender time_centered time_centered_sq | 
    SSTYPE(3)
  /METHOD=REML
  /PRINT=SOLUTION
  /RANDOM=INTERCEPT time_centered time_centered_sq | SUBJECT(ID) COVTYPE(UN)
  /SAVE=PRED RESID.

SORT CASES  BY ID.
SPLIT FILE SEPARATE BY ID.

* Chart Builder.
GGRAPH
  /GRAPHDATASET NAME="graphdataset" VARIABLES=time MEAN(pain_rating)[name="MEAN_pain_rating"] 
    obs_or_pred MISSING=LISTWISE REPORTMISSING=NO
  /GRAPHSPEC SOURCE=INLINE.
BEGIN GPL
  SOURCE: s=userSource(id("graphdataset"))
  DATA: time=col(source(s), name("time"), unit.category())
  DATA: MEAN_pain_rating=col(source(s), name("MEAN_pain_rating"))
  DATA: obs_or_pred=col(source(s), name("obs_or_pred"), unit.category())
  GUIDE: axis(dim(1), label("time"))
  GUIDE: axis(dim(2), label("Mean pain_rating"))
  GUIDE: legend(aesthetic(aesthetic.color.interior), label("obs_or_pred"))
  GUIDE: text.title(label("Multiple Line Mean of pain_rating by time by obs_or_pred"))
  SCALE: linear(dim(2), include(0))
  ELEMENT: line(position(time*MEAN_pain_rating), color.interior(obs_or_pred), missing.wings())
END GPL.

DATASET ACTIVATE DataSet26.
* Chart Builder.
GGRAPH
  /GRAPHDATASET NAME="graphdataset" VARIABLES=time MEAN(pain_rating)[name="MEAN_pain_rating"] ID 
    MISSING=LISTWISE REPORTMISSING=NO
  /GRAPHSPEC SOURCE=INLINE.
BEGIN GPL
  SOURCE: s=userSource(id("graphdataset"))
  DATA: time=col(source(s), name("time"), unit.category())
  DATA: MEAN_pain_rating=col(source(s), name("MEAN_pain_rating"))
  DATA: ID=col(source(s), name("ID"), unit.category())
  GUIDE: axis(dim(1), label("time"))
  GUIDE: axis(dim(2), label("Mean pain_rating"))
  GUIDE: legend(aesthetic(aesthetic.color.interior), label("ID"))
  GUIDE: text.title(label("Multiple Line Mean of pain_rating by time by ID"))
  SCALE: linear(dim(2), include(0))
  ELEMENT: line(position(time*MEAN_pain_rating), color.interior(ID), missing.wings())
END GPL.


MIXED pain_rating WITH age STAI_trait pain_cat cortisol_serum mindfulness gender time_centered 
    time_centered_sq
  /CRITERIA=DFMETHOD(SATTERTHWAITE) CIN(95) MXITER(100) MXSTEP(10) SCORING(1) 
    SINGULAR(0.000000000001) HCONVERGE(0, ABSOLUTE) LCONVERGE(0, ABSOLUTE) PCONVERGE(0.000001, ABSOLUTE)    
  /FIXED=age STAI_trait pain_cat cortisol_serum mindfulness gender time_centered time_centered_sq | 
    SSTYPE(3)
  /METHOD=REML
  /PRINT=SOLUTION
  /RANDOM=INTERCEPT time_centered time_centered_sq | SUBJECT(ID) COVTYPE(UN)
  /SAVE=PRED RESID.

EXAMINE VARIABLES=pain_rating BY ID
  /PLOT BOXPLOT STEMLEAF
  /COMPARE GROUPS
  /STATISTICS DESCRIPTIVES
  /CINTERVAL 95
  /MISSING LISTWISE
  /NOTOTAL.

EXAMINE VARIABLES=RESID_1 BY ID
  /PLOT BOXPLOT STEMLEAF
  /COMPARE GROUPS
  /STATISTICS EXTREME
  /MISSING LISTWISE
  /NOTOTAL.

EXAMINE VARIABLES=RESID_1
  /PLOT BOXPLOT STEMLEAF HISTOGRAM NPPLOT
  /COMPARE GROUPS
  /STATISTICS DESCRIPTIVES EXTREME
  /CINTERVAL 95
  /MISSING LISTWISE
  /NOTOTAL.

EXAMINE VARIABLES=RESID_1 BY ID
  /PLOT BOXPLOT STEMLEAF HISTOGRAM NPPLOT
  /COMPARE GROUPS
  /STATISTICS DESCRIPTIVES EXTREME
  /CINTERVAL 95
  /MISSING LISTWISE
  /NOTOTAL.

* Chart Builder.
GGRAPH
  /GRAPHDATASET NAME="graphdataset" VARIABLES=PRED_slope_square RESID_1 MISSING=LISTWISE 
    REPORTMISSING=NO
  /GRAPHSPEC SOURCE=INLINE
  /FITLINE TOTAL=NO SUBGROUP=NO.
BEGIN GPL
  SOURCE: s=userSource(id("graphdataset"))
  DATA: PRED_slope_square=col(source(s), name("PRED_slope_square"))
  DATA: RESID_1=col(source(s), name("RESID_1"))
  GUIDE: axis(dim(1), label("Predicted Values"))
  GUIDE: axis(dim(2), label("Residuals"))
  GUIDE: text.title(label("Scatter Plot of Residuals by Predicted Values"))
  ELEMENT: point(position(PRED_slope_square*RESID_1))
END GPL.

* Chart Builder.
GGRAPH
  /GRAPHDATASET NAME="graphdataset" VARIABLES=age RESID_1 MISSING=LISTWISE REPORTMISSING=NO
  /GRAPHSPEC SOURCE=INLINE
  /FITLINE TOTAL=NO SUBGROUP=NO.
BEGIN GPL
  SOURCE: s=userSource(id("graphdataset"))
  DATA: age=col(source(s), name("age"))
  DATA: RESID_1=col(source(s), name("RESID_1"))
  GUIDE: axis(dim(1), label("age"))
  GUIDE: axis(dim(2), label("Residuals"))
  GUIDE: text.title(label("Scatter Plot of Residuals by age"))
  ELEMENT: point(position(age*RESID_1))
END GPL.

* Chart Builder.
GGRAPH
  /GRAPHDATASET NAME="graphdataset" VARIABLES=STAI_trait RESID_1 MISSING=LISTWISE REPORTMISSING=NO
  /GRAPHSPEC SOURCE=INLINE
  /FITLINE TOTAL=NO SUBGROUP=NO.
BEGIN GPL
  SOURCE: s=userSource(id("graphdataset"))
  DATA: STAI_trait=col(source(s), name("STAI_trait"))
  DATA: RESID_1=col(source(s), name("RESID_1"))
  GUIDE: axis(dim(1), label("STAI_trait"))
  GUIDE: axis(dim(2), label("Residuals"))
  GUIDE: text.title(label("Scatter Plot of Residuals by STAI_trait"))
  ELEMENT: point(position(STAI_trait*RESID_1))
END GPL.

* Chart Builder.
GGRAPH
  /GRAPHDATASET NAME="graphdataset" VARIABLES=pain_cat RESID_1 MISSING=LISTWISE REPORTMISSING=NO
  /GRAPHSPEC SOURCE=INLINE
  /FITLINE TOTAL=NO SUBGROUP=NO.
BEGIN GPL
  SOURCE: s=userSource(id("graphdataset"))
  DATA: pain_cat=col(source(s), name("pain_cat"))
  DATA: RESID_1=col(source(s), name("RESID_1"))
  GUIDE: axis(dim(1), label("pain_cat"))
  GUIDE: axis(dim(2), label("Residuals"))
  GUIDE: text.title(label("Scatter Plot of Residuals by pain_cat"))
  ELEMENT: point(position(pain_cat*RESID_1))
END GPL.

* Chart Builder.
GGRAPH
  /GRAPHDATASET NAME="graphdataset" VARIABLES=cortisol_serum RESID_1 MISSING=LISTWISE 
    REPORTMISSING=NO
  /GRAPHSPEC SOURCE=INLINE
  /FITLINE TOTAL=NO SUBGROUP=NO.
BEGIN GPL
  SOURCE: s=userSource(id("graphdataset"))
  DATA: cortisol_serum=col(source(s), name("cortisol_serum"))
  DATA: RESID_1=col(source(s), name("RESID_1"))
  GUIDE: axis(dim(1), label("cortisol_serum"))
  GUIDE: axis(dim(2), label("Residuals"))
  GUIDE: text.title(label("Scatter Plot of Residuals by cortisol_serum"))
  ELEMENT: point(position(cortisol_serum*RESID_1))
END GPL.

* Chart Builder.
GGRAPH
  /GRAPHDATASET NAME="graphdataset" VARIABLES=mindfulness RESID_1 MISSING=LISTWISE REPORTMISSING=NO
  /GRAPHSPEC SOURCE=INLINE
  /FITLINE TOTAL=NO SUBGROUP=NO.
BEGIN GPL
  SOURCE: s=userSource(id("graphdataset"))
  DATA: mindfulness=col(source(s), name("mindfulness"))
  DATA: RESID_1=col(source(s), name("RESID_1"))
  GUIDE: axis(dim(1), label("mindfulness"))
  GUIDE: axis(dim(2), label("Residuals"))
  GUIDE: text.title(label("Scatter Plot of Residuals by mindfulness"))
  ELEMENT: point(position(mindfulness*RESID_1))
END GPL.

* Chart Builder.
GGRAPH
  /GRAPHDATASET NAME="graphdataset" VARIABLES=gender RESID_1 MISSING=LISTWISE REPORTMISSING=NO
  /GRAPHSPEC SOURCE=INLINE
  /FITLINE TOTAL=NO SUBGROUP=NO.
BEGIN GPL
  SOURCE: s=userSource(id("graphdataset"))
  DATA: gender=col(source(s), name("gender"), unit.category())
  DATA: RESID_1=col(source(s), name("RESID_1"))
  GUIDE: axis(dim(1), label("gender"))
  GUIDE: axis(dim(2), label("Residuals"))
  GUIDE: text.title(label("Scatter Plot of Residuals by gender"))
  SCALE: linear(dim(2), include(0))
  ELEMENT: point(position(gender*RESID_1))
END GPL.

* Chart Builder.
GGRAPH
  /GRAPHDATASET NAME="graphdataset" VARIABLES=time_centered RESID_1 MISSING=LISTWISE 
    REPORTMISSING=NO
  /GRAPHSPEC SOURCE=INLINE
  /FITLINE TOTAL=NO SUBGROUP=NO.
BEGIN GPL
  SOURCE: s=userSource(id("graphdataset"))
  DATA: time_centered=col(source(s), name("time_centered"))
  DATA: RESID_1=col(source(s), name("RESID_1"))
  GUIDE: axis(dim(1), label("time_centered"))
  GUIDE: axis(dim(2), label("Residuals"))
  GUIDE: text.title(label("Scatter Plot of Residuals by time_centered"))
  ELEMENT: point(position(time_centered*RESID_1))
END GPL.

* Chart Builder.
GGRAPH
  /GRAPHDATASET NAME="graphdataset" VARIABLES=time_centered_sq RESID_1 MISSING=LISTWISE 
    REPORTMISSING=NO
  /GRAPHSPEC SOURCE=INLINE
  /FITLINE TOTAL=NO SUBGROUP=NO.
BEGIN GPL
  SOURCE: s=userSource(id("graphdataset"))
  DATA: time_centered_sq=col(source(s), name("time_centered_sq"))
  DATA: RESID_1=col(source(s), name("RESID_1"))
  GUIDE: axis(dim(1), label("time_centered_sq"))
  GUIDE: axis(dim(2), label("Residuals"))
  GUIDE: text.title(label("Scatter Plot of Residuals by time_centered_sq"))
  ELEMENT: point(position(time_centered_sq*RESID_1))
END GPL.

CORRELATIONS
  /VARIABLES=age STAI_trait pain_cat cortisol_serum mindfulness gender time_centered 
    time_centered_sq
  /PRINT=TWOTAIL NOSIG FULL
  /MISSING=PAIRWISE.

SPSSINC CREATE DUMMIES VARIABLE=ID 
ROOTNAME1=ID_Dummy 
/OPTIONS ORDER=A USEVALUELABELS=YES USEML=YES OMITFIRST=NO.

COMPUTE RES_sq=RESID_1 * RESID_1.
EXECUTE.

REGRESSION
  /MISSING LISTWISE
  /STATISTICS COEFF OUTS R ANOVA
  /CRITERIA=PIN(.05) POUT(.10)
  /NOORIGIN 
  /DEPENDENT RES_sq
  /METHOD=ENTER ID_Dummy_2 ID_Dummy_3 ID_Dummy_4 ID_Dummy_5 ID_Dummy_6 ID_Dummy_7 ID_Dummy_8 
    ID_Dummy_9 ID_Dummy_10 ID_Dummy_11 ID_Dummy_12 ID_Dummy_13 ID_Dummy_14 ID_Dummy_15 ID_Dummy_16 
    ID_Dummy_17 ID_Dummy_18 ID_Dummy_19 ID_Dummy_20.

MIXED pain_rating WITH age STAI_trait pain_cat cortisol_serum mindfulness gender time_centered 
    time_centered_sq
  /CRITERIA=DFMETHOD(SATTERTHWAITE) CIN(95) MXITER(100) MXSTEP(10) SCORING(1) 
    SINGULAR(0.000000000001) HCONVERGE(0, ABSOLUTE) LCONVERGE(0, ABSOLUTE) PCONVERGE(0.000001, ABSOLUTE)    
  /FIXED=age STAI_trait pain_cat cortisol_serum mindfulness gender time_centered time_centered_sq | 
    SSTYPE(3)
  /METHOD=REML
  /PRINT=SOLUTION
  /RANDOM=INTERCEPT time_centered time_centered_sq | SUBJECT(ID) COVTYPE(UN) SOLUTION.
  

DATASET ACTIVATE DataSet29.
EXAMINE VARIABLES=Predictions
  /PLOT BOXPLOT STEMLEAF HISTOGRAM NPPLOT
  /COMPARE GROUPS
  /STATISTICS DESCRIPTIVES
  /CINTERVAL 95
  /MISSING LISTWISE
  /NOTOTAL.

DATASET ACTIVATE DataSet26.
MIXED pain_rating WITH age STAI_trait pain_cat cortisol_serum mindfulness gender time_centered 
    time_centered_sq
  /CRITERIA=DFMETHOD(SATTERTHWAITE) CIN(95) MXITER(100) MXSTEP(10) SCORING(1) 
    SINGULAR(0.000000000001) HCONVERGE(0, ABSOLUTE) LCONVERGE(0, ABSOLUTE) PCONVERGE(0.000001, ABSOLUTE)    
  /FIXED=age STAI_trait pain_cat cortisol_serum mindfulness gender time_centered time_centered_sq | 
    SSTYPE(3)
  /METHOD=REML
  /PRINT=CORB  SOLUTION
  /RANDOM=INTERCEPT time_centered time_centered_sq | SUBJECT(ID) COVTYPE(UN).
