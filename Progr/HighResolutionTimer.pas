unit HighResolutionTimer;
{������� � http://expert.delphi.int.ru/question/5313/}

interface
 
uses Windows;
 
type
  // --------------------- ����� - ������������ ������ -------------------------
  THRTimer = class(TObject)
    constructor Create;
    function StartTimer: Boolean; // ��������� �������
    function ReadTimer: Double;   // ������ �������� ������� � �������������
  private
    StartTime: Double;
    ClockRate: Double;
  public
    Exists: Boolean;    // ���� ��������� �������� �������
  end;

var
  Timer: THRTimer; // ��������� ����������. �������� ��� ������� ���������


{ ������� ������������ ��������.
 Delphi:
   ���������: function HRDelay(const Milliseconds: Double): Double;
   Milliseconds: Double - �������� � ������������� (����� ���� �������)
   ��������� ������� - ���������� ������������ �������� � ������������.
   ������ ������ �������: X:= HRDelay(100.0); ��� HRDelay(100.0);
}

implementation


{ THRTimer }

constructor THRTimer.Create;
var
  QW: LARGE_INTEGER;
begin
  inherited Create;
  Exists := QueryPerformanceFrequency(Int64(QW));
  ClockRate := QW.QuadPart;
end;

function THRTimer.StartTimer: Boolean;
var
  QW: LARGE_INTEGER;
begin
  Result := QueryPerformanceCounter(Int64(QW));
  StartTime := QW.QuadPart;
end;

function THRTimer.ReadTimer: Double;
var
  ET: LARGE_INTEGER;
begin
  QueryPerformanceCounter(Int64(ET));
  Result := 1000.0 * (ET.QuadPart - StartTime) / ClockRate;
end;


initialization
  Timer:= THRTimer.Create();

finalization
  Timer.Free();
end.
