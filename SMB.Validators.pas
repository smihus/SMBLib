unit SMB.Validators;
interface
uses
  System.SysUtils, Windows;

const
  TIntInputKeysSet = ['0'..'9', Chr(VK_BACK), '-', Chr(VK_RETURN), Chr(VK_TAB)];

  TFloatInputKeysSet = ['0'..'9', '-', '.', ',',
    Chr(VK_BACK), Chr(VK_DELETE), Chr(VK_RETURN), Chr(VK_TAB)];

procedure KeyPressFloat(var Key: Char);
procedure KeyPressInt(var Key: Char);

function TryStrToNumMsg(const FieldName: String; const Value: String;
  var ErrorMsg: String; var ResultValue: Extended): Boolean; overload;
function TryStrToNumMsg(const FieldName: String; const Value: String;
  var ErrorMsg: String; var ResultValue: Integer): Boolean; overload;

function IsBetween(const FieldName: String; const Value: Integer;
  const Min: Integer; const Max: Integer; var ErrorMsg: String;
  const BorderIncluded: Boolean = False): Boolean; overload;
function IsBetween(const FieldName: String; const Value: Extended;
  const Min: Extended; const Max: Extended; var ErrorMsg: String;
  const BorderIncluded: Boolean = False): Boolean; overload;
function IsBetween(const FieldName: String; const Str: String;
  const Min: Integer; const Max: Integer; var ErrorMsg: String;
  const BorderIncluded: Boolean = False): Boolean; overload;

function TryStrToBetween(const FieldName: String; const Value: String;
  const Min: Integer; const Max: Integer; var ErrorMsg: String;
  var ResultValue: Integer; const BorderIncluded: Boolean = False): Boolean; overload;
function TryStrToBetween(const FieldName: String; const Value: String;
  const Min: Extended; const Max: Extended; var ErrorMsg: String;
  var ResultValue: Extended; const BorderIncluded: Boolean = False): Boolean; overload;

function IsGreaterThan(const FieldName: String; const Value: Extended;
  const Min: Extended; var ErrorMsg: String): Boolean; overload;
function IsGreaterThan(const FieldName: String; const Value: Integer;
  const Min: Integer; var ErrorMsg: String): Boolean; overload;
function IsGreaterThan(const FieldName: String; const Str: String;
  const Min: Integer; var ErrorMsg: String): Boolean; overload;

function TryStrToGreaterThan(const FieldName: String; const Value: String;
  const Min: Extended; var ErrorMsg: String; var ResultValue: Extended): Boolean; overload;
function TryStrToGreaterThan(const FieldName: String; const Value: String;
  const Min: Integer; var ErrorMsg: String; var ResultValue: Integer): Boolean; overload;

function IsGreaterThanOrEqual(const FieldName: String; const Value: Extended;
  const Min: Extended; var ErrorMsg: String): Boolean; overload;
function IsGreaterThanOrEqual(const FieldName: String; const Value: Integer;
  const Min: Integer; var ErrorMsg: String): Boolean; overload;
function IsGreaterThanOrEqual(const FieldName: String; const Str: String;
  const Min: Integer; var ErrorMsg: String): Boolean; overload;

function TryStrToGreaterThanOrEqual(const FieldName: String; const Value: String;
  const Min: Extended; var ErrorMsg: String; var ResultValue: Extended): Boolean; overload;
function TryStrToGreaterThanOrEqual(const FieldName: String; const Value: String;
  const Min: Integer; var ErrorMsg: String; var ResultValue: Integer): Boolean; overload;

function IsLessThan(const FieldName: String; const Value: Extended;
  const Max: Extended; var ErrorMsg: String): Boolean; overload;
function IsLessThan(const FieldName: String; const Value: Integer;
  const Max: Integer; var ErrorMsg: String): Boolean; overload;
function IsLessThan(const FieldName: String; const Str: String;
  const Max: Integer; var ErrorMsg: String): Boolean; overload;

function TryStrToLessThan(const FieldName: String; const Value: String;
  const Max: Extended; var ErrorMsg: String; var ResultValue: Extended): Boolean; overload;
function TryStrToLessThan(const FieldName: String; const Value: String;
  const Max: Integer; var ErrorMsg: String; var ResultValue: Integer): Boolean; overload;

function IsLessThanOrEqual(const FieldName: String; const Value: Extended;
  const Max: Extended; var ErrorMsg: String): Boolean; overload;
function IsLessThanOrEqual(const FieldName: String; const Value: Integer;
  const Max: Integer; var ErrorMsg: String): Boolean; overload;
function IsLessThanOrEqual(const FieldName: String; const Str: String;
  const Max: Integer; var ErrorMsg: String): Boolean; overload;

function TryStrToLessThanOrEqual(const FieldName: String; const Value: String;
  const Max: Extended; var ErrorMsg: String; var ResultValue: Extended): Boolean; overload;
function TryStrToLessThanOrEqual(const FieldName: String; const Value: String;
  const Max: Integer; var ErrorMsg: String; var ResultValue: Integer): Boolean; overload;

function HasStrValue(const FieldName: String; const Value: String; var ErrorMsg: String): Boolean;

implementation

{ HasStrValue ����������:
  * True - ���� Value - �� ������ ������.
  * False - ���� Value - ����� �������, �� � ErrorMsg ������������
    ��������������� ��������� }

function HasStrValue(const FieldName: String; const Value: String; var ErrorMsg: String): Boolean;
begin
  Result := (Trim(Value) <> '');
  if not Result then
    ErrorMsg := ErrorMsg + '�������� ���� "' + FieldName + '" ������ ���� ���������.' + sLineBreak;
end;

{ KeyPressFloat ��������� ������������ ������� ������ �����, ����������� �����
  ����� � ������� ������ (� ������ ������������ ��������), � ����� ������� TAB,
  Enter, Delete � Backspace.
  ��������� ���������� ������� � ����������� ������� OnKeyPress ������� ���������
  � �������� ��������������� ����������� ��������. }

procedure KeyPressFloat(var Key: Char);
begin
  if not CharInSet(Key, TFloatInputKeysSet) then
    Key := #0
  else if CharInSet(Key, [',', '.']) then
    Key := FormatSettings.DecimalSeparator
end;

{ KeyPressInt ��������� ������������ ������� ������ �����, � ����� ������� TAB,
  Enter, Delete � Backspace.
  ��������� ���������� ������� � ����������� ������� OnKeyPress ������� ���������
  � �������� ��������������� ����������� ��������. }

procedure KeyPressInt(var Key: Char);
begin
  if not CharInSet(Key, TIntInputKeysSet) then Key := #0
end;

{ TryStrToFloatMsg ����������:
  * True - ���� Value - ����� � ��������� ������ � ���������� � ResulValue ��� �����.
  * False - ���� Value ���������� ������������� � ����� � ��������� ������,
    � ���� ������ � ResultValue ������������� 0, � � ErrorMsg ������������
    ��������������� ��������� }

function TryStrToNumMsg(const FieldName: String; const Value: String;
  var ErrorMsg: String; var ResultValue: Extended): Boolean;
begin
  Result := TryStrToFloat(Value, ResultValue);
  if not Result then
  begin
    ErrorMsg := ErrorMsg + '�������� ���� "' + FieldName
      + '" ������ ���� ������.' + sLineBreak;
    ResultValue := -1;
  end;
end;

{ TryStrToIntMsg ����������:
  * True - ���� Value - ����� ����� � ���������� � ResulValue ��� �����.
  * False - ���� Value ���������� ������������� � ����� �����,
    � ���� ������ � ResultValue ������������� 0, � � ErrorMsg ������������
    ��������������� ��������� }

function TryStrToNumMsg(const FieldName: String; const Value: String;
  var ErrorMsg: String; var ResultValue: Integer): Boolean;
begin
  Result := TryStrToInt(Value, ResultValue);
  if not Result then
  begin
    ErrorMsg := ErrorMsg + '�������� ���� "' + FieldName
      + '" ������ ���� ����� ������.' + sLineBreak;
    ResultValue := -1;
  end;
end;

{ IsBetween ����������:
  * True - ���� Value � �������� �� Min �� Max (�������
    ��� �������, ���� BorderIncluded ���������� � True
  * False - ���� Value �� ������ � �������� �� Min �� Max,
    � � ErrorMsg ������������ ��������������� ��������� }

function IsBetween(const FieldName: String; const Value: Integer;
  const Min: Integer; const Max: Integer; var ErrorMsg: String;
  const BorderIncluded: Boolean = False): Boolean; overload;
begin
  if BorderIncluded then
    Result := (Value >= Min) and (Value <= Max)
  else
    Result := (Value > Min) and (Value < Max);

  if not Result then
    if BorderIncluded then
      ErrorMsg := ErrorMsg + '�������� ���� "' + FieldName
        + '" ������ ���� � �������� �� '
        + IntToStr(Min) + ' �� ' + IntToStr(Max) + ' ������������.' + sLineBreak
    else
      ErrorMsg := ErrorMsg + '�������� ���� "' + FieldName
        + '" ������ ���� � �������� �� '
        + IntToStr(Min) + ' �� ' + IntToStr(Max) + '.' + sLineBreak;
end;

{ TryStrToBetween ����������:
  * True - ���� Value - ����� ����� � �������� �� Min �� Max (�������
    ��� �������, ���� BorderIncluded ���������� � True � ���������� � ResulValue ��� �����
  * False - ���� Value: ���������� ������������� � ����� �����,
    �� ������ � �������� �� Min �� Max. � ���� ������ � ResultValue ������������� 0,
    � � ErrorMsg ������������ ��������������� ��������� }

function TryStrToBetween(const FieldName: String; const Value: String;
  const Min: Integer; const Max: Integer; var ErrorMsg: String;
  var ResultValue: Integer; const BorderIncluded: Boolean = False): Boolean;
begin
  if TryStrToNumMsg(FieldName, Value, ErrorMsg, ResultValue) then
    Result := IsBetween(FieldName, ResultValue, Min, Max, ErrorMsg, BorderIncluded)
  else
    Result := False;
end;

{ IsBetween ����������:
  * True - ���� Value � �������� �� Min �� Max (�������
    ��� �������, ���� BorderIncluded ���������� � True
  * False - ���� Value �� ������ � �������� �� Min �� Max,
    � � ErrorMsg ������������ ��������������� ��������� }

function IsBetween(const FieldName: String; const Value: Extended;
  const Min: Extended; const Max: Extended; var ErrorMsg: String;
  const BorderIncluded: Boolean = False): Boolean; overload;
begin
  if BorderIncluded then
    Result := (Value >= Min) and (Value <= Max)
  else
    Result := (Value > Min) and (Value < Max);

  if not Result then
    if BorderIncluded then
      ErrorMsg := ErrorMsg + '�������� ���� "' + FieldName
        + '" ������ ���� � �������� �� '
        + FloatToStr(Min) + ' �� ' + FloatToStr(Max) + ' ������������.' + sLineBreak
    else
      ErrorMsg := ErrorMsg + '�������� ���� "' + FieldName
        + '" ������ ���� � �������� �� '
        + FloatToStr(Min) + ' �� ' + FloatToStr(Max) + '.' + sLineBreak;
end;

{ TryStrToBetween ����������:
  * True - ���� Value - ����� � ��������� ������ � �������� �� Min �� Max (�������
    ��� �������, ���� BorderIncluded ���������� � True � ���������� � ResulValue ��� �����
  * False - ���� Value: ���������� ������������� � ����� � ��������� ������,
    �� ������ � �������� �� Min �� Max. � ���� ������ � ResultValue ������������� 0,
    � � ErrorMsg ������������ ��������������� ��������� }

function TryStrToBetween(const FieldName: String; const Value: String;
  const Min: Extended; const Max: Extended; var ErrorMsg: String;
  var ResultValue: Extended; const BorderIncluded: Boolean = False): Boolean;
begin
  if TryStrToNumMsg(FieldName, Value, ErrorMsg, ResultValue) then
    Result := IsBetween(FieldName, ResultValue, Min, Max, ErrorMsg, BorderIncluded)
  else
    Result := False;
end;

{ IsGreaterThan ����������:
  * True - ���� Value ������ Min
  * False - ���� Value ������ ��� ����� Min,
    � ErrorMsg ������������ ��������������� ��������� }

function IsGreaterThan(const FieldName: String; const Value: Extended;
  const Min: Extended; var ErrorMsg: String): Boolean;
begin
  Result := (Value > Min);
  if not Result then
    ErrorMsg := ErrorMsg + '�������� ���� "' + FieldName + '" ������ ���� ������ '
      + FloatToStr(Min) + '.' + sLineBreak;
end;

{ TryStrToGreaterThan ����������:
  * True - ���� Value - ����� � ��������� ������ ������ Min � ���������� � ResulValue ��� �����
  * False - ���� Value: ���������� ������������� � ����� � ��������� ������,
    � ��� ������ ��� ����� Min. � ���� ������ � ResultValue ������������� 0,
    � � ErrorMsg ������������ ��������������� ��������� }

function TryStrToGreaterThan(const FieldName: String; const Value: String;
  const Min: Extended; var ErrorMsg: String; var ResultValue: Extended): Boolean;
begin
  if TryStrToNumMsg(FieldName, Value, ErrorMsg, ResultValue) then
    Result := IsGreaterThan(FieldName, ResultValue, Min, ErrorMsg)
  else
    Result := False;
end;

{ IsGreaterThanOrEqual ����������:
  * True - ���� Value ������ ��� ����� Min
  * False - ���� Value ������ Min, � ErrorMsg ������������ ��������������� ��������� }

function IsGreaterThanOrEqual(const FieldName: String; const Value: Extended;
  const Min: Extended; var ErrorMsg: String): Boolean;
begin
  Result := (Value >= Min);
  if not Result then
    ErrorMsg := ErrorMsg + '�������� ���� "' + FieldName + '" ������ ���� ������ ��� ����� '
      + FloatToStr(Min) + '.' + sLineBreak;
end;

{ TryStrToGreaterThanOrEqual ����������:
  * True - ���� Value - ����� � ��������� ������ ������ ��� ����� Min � ���������� � ResulValue ��� �����
  * False - ���� Value: ���������� ������������� � ����� � ��������� ������,
    � ��� ������ Min. � ���� ������ � ResultValue ������������� 0,
    � � ErrorMsg ������������ ��������������� ��������� }

function TryStrToGreaterThanOrEqual(const FieldName: String; const Value: String;
  const Min: Extended; var ErrorMsg: String; var ResultValue: Extended): Boolean;
begin
  if TryStrToNumMsg(FieldName, Value, ErrorMsg, ResultValue) then
    Result := IsGreaterThanOrEqual(FieldName, ResultValue, Min, ErrorMsg)
  else
    Result := False;
end;

{ IsLessThan ����������:
  * True - ���� Value ������ Max
  * False - ���� Value ������ ��� ����� Max,
    � ErrorMsg ������������ ��������������� ��������� }

function IsLessThan(const FieldName: String; const Value: Extended;
  const Max: Extended; var ErrorMsg: String): Boolean;
begin
  Result := (Value < Max);
  if not Result then
    ErrorMsg := ErrorMsg + '�������� ���� "' + FieldName + '" ������ ���� ������ '
      + FloatToStr(Max) + '.' + sLineBreak;
end;

{ TryStrToLessThan ����������:
  * True - ���� Value - ����� � ��������� ������ ������ Max � ���������� � ResulValue ��� �����
  * False - ���� Value: ���������� ������������� � ����� � ��������� ������,
    � ��� ������ ��� ����� Max. � ���� ������ � ResultValue ������������� 0,
    � � ErrorMsg ������������ ��������������� ��������� }

function TryStrToLessThan(const FieldName: String; const Value: String;
  const Max: Extended; var ErrorMsg: String; var ResultValue: Extended): Boolean;
begin
  if TryStrToNumMsg(FieldName, Value, ErrorMsg, ResultValue) then
    Result := IsLessThan(FieldName, ResultValue, Max, ErrorMsg)
  else
    Result := False;
end;

{ IsLessThanOrEqual ����������:
  * True - ���� Value ������ ��� ����� Max
  * False - ���� Value ������ Max,
    � ErrorMsg ������������ ��������������� ��������� }

function IsLessThanOrEqual(const FieldName: String; const Value: Extended;
  const Max: Extended; var ErrorMsg: String): Boolean;
begin
  Result := (Value <= Max);
  if not Result then
    ErrorMsg := ErrorMsg + '�������� ���� "' + FieldName + '" ������ ���� ������ ��� ����� '
      + FloatToStr(Max) + '.' + sLineBreak;
end;

{ TryStrToLessThanOrEqual ����������:
  * True - ���� Value - ����� � ��������� ������ ������ ��� ����� Max � ���������� � ResulValue ��� �����
  * False - ���� Value: ���������� ������������� � ����� � ��������� ������,
    � ��� ������ Max. � ���� ������ � ResultValue ������������� 0,
    � � ErrorMsg ������������ ��������������� ��������� }

function TryStrToLessThanOrEqual(const FieldName: String; const Value: String;
  const Max: Extended; var ErrorMsg: String; var ResultValue: Extended): Boolean;
begin
  if TryStrToNumMsg(FieldName, Value, ErrorMsg, ResultValue) then
    Result := IsLessThan(FieldName, ResultValue, Max, ErrorMsg)
  else
    Result := False;
end;

{ IsGreaterThan ����������:
  * True - ���� Value ������ Min
  * False - ���� Value ������ ��� ����� Min, � ErrorMsg ������������ ��������������� ��������� }

function IsGreaterThan(const FieldName: String; const Value: Integer;
  const Min: Integer; var ErrorMsg: String): Boolean;
begin
  Result := (Value > Min);
  if not Result then
    ErrorMsg := ErrorMsg + '�������� ���� "' + FieldName + '" ������ ���� ������ '
      + IntToStr(Min) + '.' + sLineBreak;
end;

{ TryStrToGreaterThan ����������:
  * True - ���� Value - ����� �����, ��� ������ Min � ���������� � ResulValue ��� �����
  * False - ���� Value: ���������� ������������� � ����� �����
    � ��� ������ ��� ����� Min. � ���� ������ � ResultValue ������������� 0,
    � � ErrorMsg ������������ ��������������� ��������� }

function TryStrToGreaterThan(const FieldName: String; const Value: String;
  const Min: Integer; var ErrorMsg: String; var ResultValue: Integer): Boolean;
begin
  if TryStrToNumMsg(FieldName, Value, ErrorMsg, ResultValue) then
    Result := IsGreaterThan(FieldName, ResultValue, Min, ErrorMsg)
  else
    Result := False;
end;

{ IsGreaterThanOrEqual ����������:
  * True - ���� Value ������ ��� ����� Min
  * False - ���� Value ������ Min, � ErrorMsg ������������ ��������������� ��������� }

function IsGreaterThanOrEqual(const FieldName: String; const Value: Integer;
  const Min: Integer; var ErrorMsg: String): Boolean;
begin
  Result := (Value >= Min);
  if not Result then
    ErrorMsg := ErrorMsg + '�������� ���� "' + FieldName + '" ������ ���� ������ ��� ����� '
      + IntToStr(Min) + '.' + sLineBreak;
end;

{ TryStrToGreaterThanOrEqual ����������:
  * True - ���� Value - ����� �����, ��� ������ ��� ����� Min � ���������� � ResulValue ��� �����
  * False - ���� Value: ���������� ������������� � ����� �����
    � ��� ������ Min. � ���� ������ � ResultValue ������������� 0,
    � � ErrorMsg ������������ ��������������� ��������� }

function TryStrToGreaterThanOrEqual(const FieldName: String; const Value: String;
  const Min: Integer; var ErrorMsg: String; var ResultValue: Integer): Boolean;
begin
  if TryStrToNumMsg(FieldName, Value, ErrorMsg, ResultValue) then
    Result := IsGreaterThanOrEqual(FieldName, ResultValue, Min, ErrorMsg)
  else
    Result := False;
end;

{ IsLessThan ����������:
  * True - ���� Value ������ Max
  * False - ���� Value ������ ��� ����� Max, � ErrorMsg ������������ ��������������� ��������� }

function IsLessThan(const FieldName: String; const Value: Integer;
  const Max: Integer; var ErrorMsg: String): Boolean;
begin
  Result := (Value < Max);
  if not Result then
    ErrorMsg := ErrorMsg + '�������� ���� "' + FieldName + '" ������ ���� ������ '
      + IntToStr(Max) + '.' + sLineBreak;
end;

{ TryStrToLessThan ����������:
  * True - ���� Value - ����� �����, ��� ������ Max � ���������� � ResulValue ��� �����
  * False - ���� Value: ���������� ������������� � ����� �����
    � ��� ������ ��� ����� Max. � ���� ������ � ResultValue ������������� 0,
    � � ErrorMsg ������������ ��������������� ��������� }

function TryStrToLessThan(const FieldName: String; const Value: String;
  const Max: Integer; var ErrorMsg: String; var ResultValue: Integer): Boolean;
begin
  if TryStrToNumMsg(FieldName, Value, ErrorMsg, ResultValue) then
    Result := IsLessThan(FieldName, ResultValue, Max, ErrorMsg)
  else
    Result := False;
end;

{ IsLessThanOrEqual ����������:
  * True - ���� Value ������ ��� ����� Max
  * False - ���� Value ������ Max, � ErrorMsg ������������ ��������������� ��������� }

function IsLessThanOrEqual(const FieldName: String; const Value: Integer;
  const Max: Integer; var ErrorMsg: String): Boolean;
begin
  Result := (Value <= Max);
  if not Result then
    ErrorMsg := ErrorMsg + '�������� ���� "' + FieldName + '" ������ ���� ������ ��� ����� '
      + IntToStr(Max) + '.' + sLineBreak;
end;

{ TryStrToLessThanOrEqual ����������:
  * True - ���� Value - ����� �����, ��� ������ ��� ����� Max � ���������� � ResulValue ��� �����
  * False - ���� Value: ���������� ������������� � ����� �����
    � ��� ������ Max. � ���� ������ � ResultValue ������������� 0,
    � � ErrorMsg ������������ ��������������� ��������� }

function TryStrToLessThanOrEqual(const FieldName: String; const Value: String;
  const Max: Integer; var ErrorMsg: String; var ResultValue: Integer): Boolean;
begin
  if TryStrToNumMsg(FieldName, Value, ErrorMsg, ResultValue) then
    Result := IsLessThanOrEqual(FieldName, ResultValue, Max, ErrorMsg)
  else
    Result := False;
end;

{ IsBetween ����������:
  * True - ���� ����� ������ Str � �������� �� Min �� Max (�������
    ��� �������, ���� BorderIncluded ���������� � True
  * False - ���� ����� ������ Str �� ������ � �������� �� Min �� Max,
    � � ErrorMsg ������������ ��������������� ��������� }

function IsBetween(const FieldName: String; const Str: String;
  const Min: Integer; const Max: Integer; var ErrorMsg: String;
  const BorderIncluded: Boolean = False): Boolean;
var
  StrLen: Integer;
begin
  StrLen := Length(Str);
  if BorderIncluded then
    Result := (StrLen >= Min) and (StrLen <= Max)
  else
    Result := (StrLen > Min) and (StrLen < Max);

  if not Result then
    if BorderIncluded then
      ErrorMsg := ErrorMsg + '����� �������� ���� "' + FieldName
        + '" ������ ���� � �������� �� '
        + IntToStr(Min) + ' �� ' + IntToStr(Max) + ' ������������.' + sLineBreak
    else
      ErrorMsg := ErrorMsg + '����� �������� ���� "' + FieldName
        + '" ������ ���� � �������� �� '
        + IntToStr(Min) + ' �� ' + IntToStr(Max) + '.' + sLineBreak;
end;

{ IsGreaterThan ����������:
  * True - ���� ����� ������ Str ������ Min
  * False - ���� ����� ������ Str ������ ��� ����� Min,
    � ErrorMsg ������������ ��������������� ��������� }

function IsGreaterThan(const FieldName: String; const Str: String;
  const Min: Integer; var ErrorMsg: String): Boolean;
var
  StrLen: Integer;
begin
  StrLen := Length(Str);
  Result := (StrLen > Min);
  if not Result then
    ErrorMsg := ErrorMsg + '����� �������� ���� "' + FieldName + '" ������ ���� ������ '
      + IntToStr(Min) + '.' + sLineBreak;
end;

{ IsGreaterThanOrEqual ����������:
  * True - ���� ����� ������ Str ������ ��� ����� Min
  * False - ���� ����� ������ Str ������ Min,
    � ErrorMsg ������������ ��������������� ��������� }

function IsGreaterThanOrEqual(const FieldName: String; const Str: String;
  const Min: Integer; var ErrorMsg: String): Boolean;
var
  StrLen: Integer;
begin
  StrLen := Length(Str);
  Result := (StrLen >= Min);
  if not Result then
    ErrorMsg := ErrorMsg + '����� �������� ���� "' + FieldName + '" ������ ���� ������ ��� ����� '
      + IntToStr(Min) + '.' + sLineBreak;
end;

{ IsLessThan ����������:
  * True - ���� ����� ������ Str ������ Max
  * False - ���� ����� ������ Str ������ ��� ����� Max,
    � ErrorMsg ������������ ��������������� ��������� }

function IsLessThan(const FieldName: String; const Str: String;
  const Max: Integer; var ErrorMsg: String): Boolean;
var
  StrLen: Integer;
begin
  StrLen := Length(Str);
  Result := (StrLen < Max);
  if not Result then
    ErrorMsg := ErrorMsg + '����� �������� ���� "' + FieldName + '" ������ ���� ������ '
      + IntToStr(Max) + '.' + sLineBreak;
end;

{ IsLessThanOrEqual ����������:
  * True - ���� ����� ������ Str ������ ��� ����� Max
  * False - ���� ����� ������ Str ������ Max,
    � ErrorMsg ������������ ��������������� ��������� }

function IsLessThanOrEqual(const FieldName: String; const Str: String;
  const Max: Integer; var ErrorMsg: String): Boolean;
var
  StrLen: Integer;
begin
  StrLen := Length(Str);
  Result := (StrLen <= Max);
  if not Result then
    ErrorMsg := ErrorMsg + '����� �������� ���� "' + FieldName + '" ������ ���� ������ ��� ����� '
      + IntToStr(Max) + '.' + sLineBreak;
end;

end.
