unit TestSMBValidator;
interface

uses
  TestFramework, Windows, System.SysUtils;

type
  TTestSMBValidator = class(TTestCase)
  private
    FErrorMsg: String;
    FFieldName: String;
    FValueInt     :Integer;
    FMinInt       :Integer;
    FMaxInt       :Integer;
  published
    procedure TestIsBetweenIntValEqualMaxNotIncludedBorder;
    procedure TestIsBetweenIntValGreaterThanMaxNotIncludedBorder;
    procedure TestIsBetweenIntValInRangeNotIncludedBorder;
    procedure TestIsBetweenIntErrorMsgString;
  end;

implementation

uses
  SMB.Validators;

{ TTestSMBValidators }
procedure TTestSMBValidator.TestIsBetweenIntErrorMsgString;
var
  ExpectedStr: String;
begin
  FFieldName := '�������� ����';
  FValueInt     := 100;
  FMinInt       := -10;
  FMaxInt       := 10;
  IsBetween(FFieldName, FValueInt, FMinInt, FMaxInt, FErrorMsg);
  ExpectedStr := '�������� ���� "�������� ����" ������ ���� � �������� �� -10 �� 10.' + sLineBreak;
  CheckTrue(FErrorMsg = ExpectedStr);
end;

procedure TTestSMBValidator.TestIsBetweenIntValEqualMaxNotIncludedBorder;
begin
  FFieldName := '�������� ����';
  FValueInt     := 10;
  FMinInt       := -10;
  FMaxInt       := 10;
  CheckFalse(IsBetween(FFieldName, FValueInt, FMinInt, FMaxInt, FErrorMsg));
end;

procedure TTestSMBValidator.TestIsBetweenIntValGreaterThanMaxNotIncludedBorder;
begin
  FFieldName := '�������� ����';
  FValueInt     := 100;
  FMinInt       := -10;
  FMaxInt       := 10;
  CheckFalse(IsBetween(FFieldName, FValueInt, FMinInt, FMaxInt, FErrorMsg));
end;

procedure TTestSMBValidator.TestIsBetweenIntValInRangeNotIncludedBorder;
begin
  FFieldName := '�������� ����';
  FValueInt     := 5;
  FMinInt       := -10;
  FMaxInt       := 10;
  CheckTrue(IsBetween(FFieldName, FValueInt, FMinInt, FMaxInt, FErrorMsg));
end;

initialization
  // Register any test cases with the test runner
  RegisterTest(TTestSMBValidator.Suite);
end.

