unit OApproxNew;

interface

uses
  IniFiles, OlegVector, OlegType,
  OlegVectorManipulation, TeEngine, OlegTypePart2,
  Forms, FrameButtons, OlegFunction, Classes, OlegMathShottky
  {XP Win}
  ,System.UITypes
  ;

type

  TVar_RandNew=(vr_lin,vr_ln,vr_const);
  {��� ������, �� ���������������� � ����������� �������,
  vr_lin - ���������� �������� �����
  vr_ln - ���������� �������� ������������ ��������� �����
  vr_const - ����� ���������� ������}

  TEvolutionTypeNew= //����������� �����, ���� ��������������� ��� ������������
    (etDE, //differential evolution
     etEBLSHADE, //
     etADELI,//DE with the Lagrange interpolation argument
     etNDE,// DE with  with neighborhood-based adaptive mechanism
     etMABC, // modified artificial bee colony
     etTLBO,  //teaching learning based optimization algorithm
     etGOTLBO,//generalized oppositional  TLBO
     etSTLBO,//Simplified TLBO
     etPSO,    // particle swarm optimization
     etIJAYA, //improved JAVA
     etISCA,   //improved sine cosine algorithm
     etNNA,  //Neural network  algorithm
     et_CWOA,  // Chaotic Whale Optimization Algorithm
     et_WaterWave// Water wave optimization
     );
  {}
  TFitnessType=
   (ftSR,//the sum of squared residuals �������� ����������� �����
    ftRSR,//the sum relative of squared residuals ����������� ����� � �������� �������
    ftAR,//���� ������ ������
    ftRAR,//���� ������ �������� ������
    ftArea//������ ����, ���.PROGRESS  IN  PHOTOVOLTAICS: RESEARCH  AND APPLICATIONS,  VOL  1,  93-106 (1993)
   );

  TRegulationType=(rtL2,rtL1);

const
 Var_RandNames:array[TVar_RandNew]of string=
           ('Normal','Logarithmic','Constant');


 EvTypeNames:array[TEvolutionTypeNew]of string=
         ('DE','EBLSHADE','ADELI','NDE','MABC','TLBO','GOTLBO','STLBO',
         'PSO','IJAYA','ISCA','NNA','CWOA','WaterWave');

 FitTypeNames:array[TFitnessType]of string=
         ('Sq.Err.','Rel.Sq.Res.','Abs.Err.','Rel.Abs.Err.',
          'Area');

 RegTypeNames:array[TRegulationType]of string=
         ('L2','L1');

type

TOIniFileNew=class (TIniFile)
public
  function ReadRand(const Section, Ident: string): TVar_RandNew; virtual;
  procedure WriteRand(const Section, Ident: string; Value: TVar_RandNew); virtual;
  function ReadEvType(const Section, Ident: string): TEvolutionTypeNew; virtual;
  procedure WriteEvType(const Section, Ident: string; Value: TEvolutionTypeNew); virtual;
  function ReadFitType(const Section, Ident: string): TFitnessType; virtual;
  procedure WriteFitType(const Section, Ident: string; Value: TFitnessType); virtual;
  function ReadRegType(const Section, Ident: string): TRegulationType; virtual;
  procedure WriteRegType(const Section, Ident: string; Value: TRegulationType); virtual;
end;

TFFParameter=class
  protected
  public
   procedure FormPrepare(Form:TForm);virtual;abstract;
   procedure UpDate;virtual;abstract;
   procedure FormClear;virtual;abstract;
   Procedure WriteToIniFile;virtual;abstract;
   Procedure ReadFromIniFile;virtual;abstract;
   function IsReadyToFitDetermination:boolean;virtual;abstract;
end;

TWindowShow=class
  protected
   fForm:TForm;
   fButtons:TFrBut;
   procedure CreateForm;
   procedure UpDate;virtual;
   procedure AdditionalFormClear;virtual;
   procedure AdditionalFormPrepare;virtual;
  public
   procedure Show;
 end;


TFFWindowShow=class(TWindowShow)
  protected
   fPS:TFFParameter;
  public
   constructor Create(PS:TFFParameter);
end;

TFitFunctionNew=class(TObject)
{����������� ���� ��� ������������,
�� ���� ���������� ���������}
private
 FName:string;//��'� �������
 FCaption:string; // ���� �������
 fIsReadyToFit:boolean; //True, ���� ��� ������ ��� ���������� ������������
 fDiapazon:TDiapazon; //��� � ���� ���������� ������������
 fConfigFile:TOIniFileNew;//��� ������ � .ini-������
 fFileHeader:string;
 {����� ������� � ���� � ������������ ������������,
 �� ����������� ��������� FittingToGraphAndFile}
 fParameter:TFFParameter;
 fWShow:TFFWindowShow;
 fDigitNumber:byte;
 //������� ����, �� ���������� ��� ����� �����, �� ������������� 8
 fFileSuffix:string;
 //��, �� �������� �� ���� ����� ��� ����� ����������, �� ������������� 'fit'
 procedure ParameterDestroy;virtual;
 function FittingBegin:boolean;
protected
 fResultsIsReady:boolean; //True, ���� ������������ ����� ��������
 fHasPicture:boolean;//�������� ��������
 fDataToFit:TVectorTransform; //��� ��� ������������
 FPictureName:string;//��'�  ������� � ��������, �� ���������� FName+'Fig';
 ftempVector: TVectorShottky;//��������� �������
 procedure DataContainerCreate;virtual;
 procedure DataContainerDestroy;virtual;
 procedure AccessorialDataCreate;virtual;
 procedure AccessorialDataDestroy;virtual;
 function ParameterCreate:TFFParameter;virtual;
 procedure RealFitting;virtual;abstract;
 Procedure RealToFile;virtual;
 procedure SetNameCaption(FunctionName,FunctionCaption:string);
 procedure NamesDefine;virtual;abstract;
 procedure TuningAfterReadFromIni;virtual;
 procedure TuningBeforeAccessorialDataCreate;virtual;
 function RealFinalFunc(X:double):double;virtual;
 procedure DataPreraration(InputFileName:string);overload;virtual;
 procedure DataPreraration(InputData: TVector);overload;virtual;
 procedure RealToGraph (Series: TChartSeries);virtual;
 procedure VariousPreparationBeforeFitting;virtual;
public
 FittingData:TVector;
 property FileHeader:string read fFileHeader write fFileHeader;
 property DataToFit:TVectorTransform read fDataToFit;
 property Name:string read FName;
 property PictureName:string read FPictureName;
 property Caption:string read FCaption;
 property ResultsIsReady:boolean read fResultsIsReady write fResultsIsReady;
 property HasPicture:boolean read fHasPicture;
 property IsReadyToFit:boolean read fIsReadyToFit;
 property Diapazon:TDiapazon read fDiapazon;
 property ConfigFile:TOIniFileNew read fConfigFile;
 property DigitNumber:byte read fDigitNumber write fDigitNumber;
 property FileSuffix:string read fFileSuffix write fFileSuffix;
 Constructor Create;//virtual;//overload;
 destructor Destroy;override;
 procedure SetParametersGR;//virtual;
 Procedure IsReadyToFitDetermination;//virtual;
 {�� ��������� ���� �����������, �� ����� ��� ��
 ������������}
 Procedure Fitting (InputData:TVector);overload;//virtual;abstract;
 Procedure Fitting (InputFileName:string);overload;//virtual;abstract;
 Procedure FittingToGraphAndFile(InputData:TVector;
              Series: TChartSeries; SaveFile:boolean=True);virtual;
 Function FinalFunc(X:double):double;
 {������������ �������� ������������ ������� �
 ����� � �������� �;
 ��� ResultsIsReady=False ������� ErResult}
 Procedure DataToStrings(OutStrings:TStrings);virtual;
 {���������� � OutStrings ���������� ������������...
 ���������� ����� ��������� ����� �� ������������ �������}
 Procedure ParameterNamesToArray(var Arr:TArrStr);virtual;
 {��������� ����� ���������, �� ������������ ��� ������������,
 �� Arr; ���� ����� �� �����������, �� � ��� Arr �� ����������}
 function ParametersNumber:byte;virtual;
 {������� ���������, �� ������������ ��� ������������}
 function ParameterName(i:byte):string;virtual;
 {������� ����� �-�� ���������, ��
 ����������� ��� ������������}
 function ParameterIndexByName(Name:string):integer;virtual;
 procedure OutputDataImport(Source:TArrSingle);virtual;
 procedure OutputDataExport(Target:TArrSingle);virtual;
end;   // TFitFunctionNew=class

//--------------------------------------------------------------------

TFFWindowShowBase=class(TFFWindowShow)
 private
  fFF:TFitFunctionNew;
 protected
  procedure UpDate;override;
  procedure AdditionalFormClear;override;
  procedure AdditionalFormPrepare;override;
 public
  constructor Create(FF:TFitFunctionNew);
end;



var
 FitFunctionNew:TFitFunctionNew;
 EvolParam:TArrSingle;
{����� � double, ��������������� � ����������� ����������}

Function StepDeterminationNew(Xmin,Xmax:double;Npoint:integer;
                   Var_Rand:TVar_RandNew):double;
{���� ��� ���� �������� � ��������
[Xmin, Xmax] � ��������� �������
����� Npoint;
Var_Rand  ���� ������� ���� (������ �� ������������)
� ���������� ������� �����������
���������� �������� �����
}



implementation

uses
  SysUtils, Dialogs, OApproxShow, Graphics, Math, Controls, TypInfo;

{ TOIniFileNew }

function TOIniFileNew.ReadEvType(const Section, Ident: string): TEvolutionTypeNew;
begin
  try
    Result:=TEvolutionTypeNew(ReadInteger(Section, Ident,0));
  except
    Result:=TEvolutionTypeNew(0);
  end;
end;

function TOIniFileNew.ReadFitType(const Section, Ident: string): TFitnessType;
begin
  try
    Result:=TFitnessType(ReadInteger(Section, Ident,1));
  except
    Result:=TFitnessType(1);
  end;
end;

function TOIniFileNew.ReadRand(const Section, Ident: string): TVar_RandNew;
begin
  try
    Result:=TVar_RandNew(ReadInteger(Section, Ident,0));
  except
    Result:=TVar_RandNew(0);
  end;
end;

function TOIniFileNew.ReadRegType(const Section,
  Ident: string): TRegulationType;
begin
  try
    Result:=TRegulationType(ReadInteger(Section, Ident,0));
  except
    Result:=TRegulationType(0);
  end;
end;

procedure TOIniFileNew.WriteEvType(const Section, Ident: string;
  Value: TEvolutionTypeNew);
begin
 WriteInteger(Section, Ident,ord(Value));
end;

procedure TOIniFileNew.WriteFitType(const Section, Ident: string;
  Value: TFitnessType);
begin
 WriteInteger(Section, Ident,ord(Value));
end;

procedure TOIniFileNew.WriteRand(const Section, Ident: string;
                                 Value: TVar_RandNew);
begin
  WriteInteger(Section, Ident,ord(Value));
end;

procedure TOIniFileNew.WriteRegType(const Section, Ident: string;
  Value: TRegulationType);
begin
  WriteInteger(Section, Ident,ord(Value));
end;

{ TFitFunctionNew }

constructor TFitFunctionNew.Create;
begin
 inherited Create;
{XP Win}
 FormatSettings.DecimalSeparator:='.';
// DecimalSeparator:='.';
 NamesDefine;
 fDigitNumber:=8;
 fFileSuffix:='fit';
 fHasPicture:=True;
 FPictureName:=FName+'Fig';
 fIsReadyToFit:=False;
 fResultsIsReady:=False;
 fFileHeader:='X Y Yfit';
 TuningBeforeAccessorialDataCreate;

 DataContainerCreate;
 AccessorialDataCreate;

 fConfigFile:=TOIniFileNew.Create(ExtractFilePath(Application.ExeName)+'Shottky.ini');

 fParameter:=ParameterCreate;
 fWShow:=TFFWindowShowBase.Create(Self);
 fParameter.ReadFromIniFile;
 IsReadyToFitDetermination;

 TuningAfterReadFromIni;
end;



procedure TFitFunctionNew.DataContainerCreate;
begin
  fDataToFit:=TVectorTransform.Create;
  ftempVector:=TVectorShottky.Create;
  FittingData:=TVector.Create;
end;

procedure TFitFunctionNew.DataContainerDestroy;
begin
  fDataToFit.Free;
  ftempVector.Free;
  FittingData.Free;
end;

procedure TFitFunctionNew.DataPreraration(InputData: TVector);
begin
  ftempVector.CopyFrom(InputData);
  ftempVector.N_Begin := 0;
  ftempVector.CopyDiapazonPoint(fDataToFit, fDiapazon);
end;

procedure TFitFunctionNew.DataPreraration(InputFileName: string);
begin
  ftempVector.ReadFromFile(InputFileName);
  ftempVector.CopyDiapazonPoint(fDataToFit, fDiapazon);
end;

procedure TFitFunctionNew.DataToStrings(OutStrings: TStrings);
begin
 OutStrings.Add(fDataToFit.name);
end;

destructor TFitFunctionNew.Destroy;
begin
  DataContainerDestroy;
  AccessorialDataDestroy;
  ParameterDestroy;
  fConfigFile.Free;
  inherited;
end;

procedure TFitFunctionNew.AccessorialDataDestroy;
begin
 fDiapazon.Free;
end;

procedure TFitFunctionNew.AccessorialDataCreate;
begin
 fDiapazon:=TDiapazon.Create;
end;

procedure TFitFunctionNew.IsReadyToFitDetermination;
begin
 fIsReadyToFit:=fParameter.IsReadyToFitDetermination;
end;

procedure TFitFunctionNew.OutputDataExport(Target: TArrSingle);
begin
  SetLength(Target,1);
  Target[0]:=ErResult;
end;

procedure TFitFunctionNew.OutputDataImport(Source: TArrSingle);
begin
 fResultsIsReady:=True;
end;

function TFitFunctionNew.FinalFunc(X: double): double;
begin
 if fResultsIsReady then Result:=RealFinalFunc(X)
                    else Result:=ErResult;
end;

procedure TFitFunctionNew.Fitting(InputFileName: string);
begin
 DataPreraration(InputFileName);
 if FittingBegin then RealFitting;
 if not(FittingData.IsEmpty) then fResultsIsReady:=True;
end;

procedure TFitFunctionNew.Fitting(InputData: TVector);
begin
 DataPreraration(InputData);
 if FittingBegin then RealFitting;
 if not(FittingData.IsEmpty)
      then fResultsIsReady:=True
      else
   MessageDlg('Approximation unseccessful', mtError,[mbOk],0);
end;


function TFitFunctionNew.RealFinalFunc(X: double): double;
begin
 Result:=FittingData.Yvalue(X);
end;

procedure TFitFunctionNew.RealToFile;
 var Str1:TStringList;
    i:integer;
begin
  Str1:=TStringList.Create;
  if fFileHeader<>'' then Str1.Add(fFileHeader);
  for I := 0 to fDataToFit.HighNumber do
    Str1.Add(fDataToFit.PoinToString(i,DigitNumber)
             +' '
             +FloatToStrF(FittingData.Y[i],ffExponent,DigitNumber,0));
  Str1.SaveToFile(FitName(fDataToFit,FileSuffix));
  Str1.Free;
end;

procedure TFitFunctionNew.RealToGraph(Series: TChartSeries);
begin
 FittingData.WriteToGraph(Series);
end;

procedure TFitFunctionNew.SetNameCaption(FunctionName, FunctionCaption: string);
begin
 FName:=FunctionName;
 FCaption:=FunctionCaption;
end;

procedure TFitFunctionNew.SetParametersGR;
begin
 fWShow.Show;
end;

procedure TFitFunctionNew.TuningAfterReadFromIni;
begin

end;

procedure TFitFunctionNew.TuningBeforeAccessorialDataCreate;
begin

end;

procedure TFitFunctionNew.VariousPreparationBeforeFitting;
begin
 IsReadyToFitDetermination;
end;

function TFitFunctionNew.FittingBegin: boolean;
begin
 VariousPreparationBeforeFitting;
 fResultsIsReady:=false;
 FittingData.Clear;
 Result:=False;
 if fDataToFit.IsEmpty then
    begin
       MessageDlg('No data to fit',mtWarning, [mbOk], 0);
       Exit;
    end;
 if not(fIsReadyToFit) then
     begin
       SetParametersGR;
       if not(fIsReadyToFit) then
         begin
          MessageDlg('Fitting is imposible.'+#10+#13+
            'To tune options, please',mtWarning, [mbOk], 0);
          Exit;
         end;
     end;
 Result:=True;
end;

procedure TFitFunctionNew.FittingToGraphAndFile(InputData: TVector;
                    Series: TChartSeries; SaveFile:boolean=True);
begin
  Fitting(InputData);
  if not(fResultsIsReady) then Exit;
  RealToGraph(Series);
  if SaveFile then
          RealToFile;
end;

function TFitFunctionNew.ParameterCreate:TFFParameter;
begin
 Result:=TFFParameterBase.Create(Self);
end;

procedure TFitFunctionNew.ParameterDestroy;
begin
 fWShow.Free;
 fParameter.Free;
end;


function TFitFunctionNew.ParameterIndexByName(Name: string): integer;
begin
 Result:=-1;
end;

function TFitFunctionNew.ParameterName(i: byte): string;
begin
 Result:='None';
end;

procedure TFitFunctionNew.ParameterNamesToArray(var Arr: TArrStr);
begin
end;

function TFitFunctionNew.ParametersNumber: byte;
begin
 Result:=0;
end;

{ TWindowShow }

constructor TFFWindowShow.Create(PS: TFFParameter);
begin
  inherited Create;
  fPS:=PS;
end;

{ TWindowShowBase }

procedure TFFWindowShowBase.AdditionalFormClear;
begin
  inherited;
  fPS.FormClear;
end;

procedure TFFWindowShowBase.AdditionalFormPrepare;
begin
 inherited;
 fForm.Caption := 'Parameters of ' + fFF.Name + ' function';
 fPS.FormPrepare(fForm);
end;

constructor TFFWindowShowBase.Create(FF: TFitFunctionNew);
begin
 fFF:=FF;
 inherited Create(fFF.fParameter);
end;

procedure TFFWindowShowBase.UpDate;
begin
  inherited;
  fPS.UpDate;
  fFF.IsReadyToFitDetermination;
  if fFF.IsReadyToFit then  fFF.fParameter.WriteToIniFile;
end;

{ TWindowShow }

procedure TWindowShow.AdditionalFormPrepare;
begin
end;

procedure TWindowShow.CreateForm;
begin
  fForm := TForm.Create(Application);
  fForm.Position := poMainFormCenter;
  fForm.AutoScroll := True;
  fForm.BorderIcons := [biSystemMenu];
  fForm.ParentFont := True;
  fForm.Font.Style := [fsBold];
  fForm.Caption := 'Some Captions';
  fForm.Color := clLtGray;

  AdditionalFormPrepare;

  fButtons := TFrBut.Create(fForm);
  fButtons.Parent := fForm;
  fButtons.Left := 10;
  fButtons.Top := fForm.Height+MarginTop;

  fForm.Width:=max(fForm.Width,fButtons.Width)+MarginLeft+10;
  fForm.Height:=fButtons.Top+fButtons.Height+2*MarginTop+10;
end;

procedure TWindowShow.UpDate;
begin
end;

procedure TWindowShow.AdditionalFormClear;
begin
end;

procedure TWindowShow.Show;
begin
 CreateForm;

 if fForm.ShowModal=mrOk then UpDate;

 AdditionalFormClear;
 fButtons.Parent:=nil;
 fButtons.Free;
 ElementsFromForm(fForm);

 fForm.Hide;
 fForm.Release;
end;


Function StepDeterminationNew(Xmin,Xmax:double;Npoint:integer;
                   Var_Rand:TVar_RandNew):double;
begin
 if Npoint<1 then Result:=ErResult
   else if (Npoint=1)or(Var_Rand=vr_const) then Result:=(Xmax-Xmin)+1
        else if (Xmax=Xmin) then Result:=1
         else
         case Var_Rand of
          vr_lin:Result:=(Xmax-Xmin)/(Npoint-1);
          else Result:=(Log10(Xmax)-Log10(Xmin))/(Npoint-1);
         end;
end;

end.
