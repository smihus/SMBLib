unit SMB.Validators;
interface
uses
  System.SysUtils, Windows;

const
  TIntInputKeysSet = ['+', '-', '0'..'9', Chr(VK_BACK), Chr(VK_DELETE),
    Chr(VK_RETURN), Chr(VK_TAB)];

  TFloatInputKeysSet = ['+', '-', '0'..'9', '.', ',',
    Chr(VK_BACK), Chr(VK_DELETE), Chr(VK_RETURN), Chr(VK_TAB)];

procedure KeyPressFloat(var Key: Char);

procedure KeyPressInt(var Key: Char);

function IsBetween(const FieldName: String; const Value: Integer;
  const Min: Integer; const Max: Integer; var ErrorMsg: String;
  const BorderIncluded: Boolean = False): Boolean; overload;

function IsBetween(const FieldName: String; const Value: Extended;
  const Min: Extended; const Max: Extended; var ErrorMsg: String;
  const BorderIncluded: Boolean = False): Boolean; overload;

function TryStrToBetween(const FieldName: String; const Value: String;
  const Min: Integer; const Max: Integer; var ErrorMsg: String;
  var ResultValue: Integer; const BorderIncluded: Boolean = False): Boolean; overload;

function TryStrToBetween(const FieldName: String; const Value: String;
  const Min: Extended; const Max: Extended; var ErrorMsg: String;
  var ResultValue: Extended; const BorderIncluded: Boolean = False): Boolean; overload;

function IsGreaterThanFloat(const FieldName: String; const Value: Extended;
  const Min: Extended; var ErrorMsg: String): Boolean;

function TryStrToGreaterThanFloat(const FieldName: String; const Value: String;
  const Min: Extended; var ErrorMsg: String; var ResultValue: Extended): Boolean;

function IsGreaterThanOrEqualFloat(const FieldName: String; const Value: Extended;
  const Min: Extended; var ErrorMsg: String): Boolean;

function TryStrToGreaterThanOrEqualFloat(const FieldName: String; const Value: String;
  const Min: Extended; var ErrorMsg: String; var ResultValue: Extended): Boolean;

function IsLessThanFloat(const FieldName: String; const Value: Extended;
  const Max: Extended; var ErrorMsg: String): Boolean;

function TryStrToLessThanFloat(const FieldName: String; const Value: String;
  const Max: Extended; var ErrorMsg: String; var ResultValue: Extended): Boolean;

function IsLessThanOrEqualFloat(const FieldName: String; const Value: Extended;
  const Max: Extended; var ErrorMsg: String): Boolean;

function TryStrToLessThanOrEqualFloat(const FieldName: String; const Value: String;
  const Max: Extended; var ErrorMsg: String; var ResultValue: Extended): Boolean;

function TryStrToFloatMsg(const FieldName: String; const Value: String;
  var ErrorMsg: String; var ResultValue: Extended): Boolean;

function TryStrToIntMsg(const FieldName: String; const Value: String;
  var ErrorMsg: String; var ResultValue: Integer): Boolean;

function IsGreaterThanInt(const FieldName: String; const Value: Integer;
  const Min: Integer; var ErrorMsg: String): Boolean;

function TryStrToGreaterThanInt(const FieldName: String; const Value: String;
  const Min: Integer; var ErrorMsg: String; var ResultValue: Integer): Boolean;

function IsGreaterThanOrEqualInt(const FieldName: String; const Value: Integer;
  const Min: Integer; var ErrorMsg: String): Boolean;

function TryStrToGreaterThanOrEqualInt(const FieldName: String; const Value: String;
  const Min: Integer; var ErrorMsg: String; var ResultValue: Integer): Boolean;

function IsLessThanInt(const FieldName: String; const Value: Integer;
  const Max: Integer; var ErrorMsg: String): Boolean;

function TryStrToLessThanInt(const FieldName: String; const Value: String;
  const Max: Integer; var ErrorMsg: String; var ResultValue: Integer): Boolean;

function IsLessThanOrEqualInt(const FieldName: String; const Value: Integer;
  const Max: Integer; var ErrorMsg: String): Boolean;

function TryStrToLessThanOrEqualInt(const FieldName: String; const Value: String;
  const Max: Integer; var ErrorMsg: String; var ResultValue: Integer): Boolean;

function HasStrValue(const FieldName: String; const Value: String; var ErrorMsg: String): Boolean;

function IsBetweenStr(const FieldName: String; const Str: String;
  const Min: Integer; const Max: Integer; var ErrorMsg: String;
  const BorderIncluded: Boolean = False): Boolean;

function IsGreaterThanStr(const FieldName: String; const Str: String;
  const Min: Integer; var ErrorMsg: String): Boolean;

function IsGreaterThanOrEqualStr(const FieldName: String; const Str: String;
  const Min: Integer; var ErrorMsg: String): Boolean;

function IsLessThanStr(const FieldName: String; const Str: String;
  const Max: Integer; var ErrorMsg: String): Boolean;

function IsLessThanOrEqualStr(const FieldName: String; const Str: String;
  const Max: Integer; var ErrorMsg: String): Boolean;

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

function TryStrToFloatMsg(const FieldName: String; const Value: String;
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

function TryStrToIntMsg(const FieldName: String; const Value: String;
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

{ TryStrToBetweenInt ����������:
  * True - ���� Value - ����� ����� � �������� �� Min �� Max (�������
    ��� �������, ���� BorderIncluded ���������� � True � ���������� � ResulValue ��� �����
  * False - ���� Value: ���������� ������������� � ����� �����,
    �� ������ � �������� �� Min �� Max. � ���� ������ � ResultValue ������������� 0,
    � � ErrorMsg ������������ ��������������� ��������� }

function TryStrToBetween(const FieldName: String; const Value: String;
  const Min: Integer; const Max: Integer; var ErrorMsg: String;
  var ResultValue: Integer; const BorderIncluded: Boolean = False): Boolean; overload;
begin
  if TryStrToIntMsg(FieldName, Value, ErrorMsg, ResultValue) then
    Result := IsBetween(FieldName, ResultValue, Min, Max, ErrorMsg, BorderIncluded)
  else
    Result := False;
end;

{ IsBetweenFloat ����������:
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

{ TryStrToBetweenFloat ����������:
  * True - ���� Value - ����� � ��������� ������ � �������� �� Min �� Max (�������
    ��� �������, ���� BorderIncluded ���������� � True � ���������� � ResulValue ��� �����
  * False - ���� Value: ���������� ������������� � ����� � ��������� ������,
    �� ������ � �������� �� Min �� Max. � ���� ������ � ResultValue ������������� 0,
    � � ErrorMsg ������������ ��������������� ��������� }

function TryStrToBetween(const FieldName: String; const Value: String;
  const Min: Extended; const Max: Extended; var ErrorMsg: String;
  var ResultValue: Extended; const BorderIncluded: Boolean = False): Boolean; overload;
begin
  if TryStrToFloatMsg(FieldName, Value, ErrorMsg, ResultValue) then
    Result := IsBetween(FieldName, ResultValue, Min, Max, ErrorMsg, BorderIncluded)
  else
    Result := False;
end;

{ IsGreaterThanFloat ����������:
  * True - ���� Value ������ Min
  * False - ���� Value ������ ��� ����� Min,
    � ErrorMsg ������������ ��������������� ��������� }

function IsGreaterThanFloat(const FieldName: String; const Value: Extended;
  const Min: Extended; var ErrorMsg: String): Boolean;
begin
  Result := (Value > Min);
  if not Result then
    ErrorMsg := ErrorMsg + '�������� ���� "' + FieldName + '" ������ ���� ������ '
      + FloatToStr(Min) + '.' + sLineBreak;
end;

{ TryStrToGreaterThanFloat ����������:
  * True - ���� Value - ����� � ��������� ������ ������ Min � ���������� � ResulValue ��� �����
  * False - ���� Value: ���������� ������������� � ����� � ��������� ������,
    � ��� ������ ��� ����� Min. � ���� ������ � ResultValue ������������� 0,
    � � ErrorMsg ������������ ��������������� ��������� }

function TryStrToGreaterThanFloat(const FieldName: String; const Value: String;
  const Min: Extended; var ErrorMsg: String; var ResultValue: Extended): Boolean;
begin
  if TryStrToFloatMsg(FieldName, Value, ErrorMsg, ResultValue) then
    Result := IsGreaterThanFloat(FieldName, ResultValue, Min, ErrorMsg)
  else
    Result := False;
end;

{ IsGreaterThanOrEqualFloat ����������:
  * True - ���� Value ������ ��� ����� Min
  * False - ���� Value ������ Min, � ErrorMsg ������������ ��������������� ��������� }

function IsGreaterThanOrEqualFloat(const FieldName: String; const Value: Extended;
  const Min: Extended; var ErrorMsg: String): Boolean;
begin
  Result := (Value >= Min);
  if not Result then
    ErrorMsg := ErrorMsg + '�������� ���� "' + FieldName + '" ������ ���� ������ ��� ����� '
      + FloatToStr(Min) + '.' + sLineBreak;
end;

{ TryStrToGreaterThanOrEqualFloat ����������:
  * True - ���� Value - ����� � ��������� ������ ������ ��� ����� Min � ���������� � ResulValue ��� �����
  * False - ���� Value: ���������� ������������� � ����� � ��������� ������,
    � ��� ������ Min. � ���� ������ � ResultValue ������������� 0,
    � � ErrorMsg ������������ ��������������� ��������� }

function TryStrToGreaterThanOrEqualFloat(const FieldName: String; const Value: String;
  const Min: Extended; var ErrorMsg: String; var ResultValue: Extended): Boolean;
begin
  if TryStrToFloatMsg(FieldName, Value, ErrorMsg, ResultValue) then
    Result := IsGreaterThanOrEqualFloat(FieldName, ResultValue, Min, ErrorMsg)
  else
    Result := False;
end;

{ IsLessThanFloat ����������:
  * True - ���� Value ������ Max
  * False - ���� Value ������ ��� ����� Max,
    � ErrorMsg ������������ ��������������� ��������� }

function IsLessThanFloat(const FieldName: String; const Value: Extended;
  const Max: Extended; var ErrorMsg: String): Boolean;
begin
  Result := (Value < Max);
  if not Result then
    ErrorMsg := ErrorMsg + '�������� ���� "' + FieldName + '" ������ ���� ������ '
      + FloatToStr(Max) + '.' + sLineBreak;
end;

{ TryStrToLessThanFloat ����������:
  * True - ���� Value - ����� � ��������� ������ ������ Max � ���������� � ResulValue ��� �����
  * False - ���� Value: ���������� ������������� � ����� � ��������� ������,
    � ��� ������ ��� ����� Max. � ���� ������ � ResultValue ������������� 0,
    � � ErrorMsg ������������ ��������������� ��������� }

function TryStrToLessThanFloat(const FieldName: String; const Value: String;
  const Max: Extended; var ErrorMsg: String; var ResultValue: Extended): Boolean;
begin
  if TryStrToFloatMsg(FieldName, Value, ErrorMsg, ResultValue) then
    Result := IsLessThanFloat(FieldName, ResultValue, Max, ErrorMsg)
  else
    Result := False;
end;

{ IsLessThanOrEqualFloat ����������:
  * True - ���� Value ������ ��� ����� Max
  * False - ���� Value ������ Max,
    � ErrorMsg ������������ ��������������� ��������� }

function IsLessThanOrEqualFloat(const FieldName: String; const Value: Extended;
  const Max: Extended; var ErrorMsg: String): Boolean;
begin
  Result := (Value <= Max);
  if not Result then
    ErrorMsg := ErrorMsg + '�������� ���� "' + FieldName + '" ������ ���� ������ ��� ����� '
      + FloatToStr(Max) + '.' + sLineBreak;
end;

{ TryStrToLessThanOrEqualFloat ����������:
  * True - ���� Value - ����� � ��������� ������ ������ ��� ����� Max � ���������� � ResulValue ��� �����
  * False - ���� Value: ���������� ������������� � ����� � ��������� ������,
    � ��� ������ Max. � ���� ������ � ResultValue ������������� 0,
    � � ErrorMsg ������������ ��������������� ��������� }

function TryStrToLessThanOrEqualFloat(const FieldName: String; const Value: String;
  const Max: Extended; var ErrorMsg: String; var ResultValue: Extended): Boolean;
begin
  if TryStrToFloatMsg(FieldName, Value, ErrorMsg, ResultValue) then
    Result := IsLessThanFloat(FieldName, ResultValue, Max, ErrorMsg)
  else
    Result := False;
end;

{ IsGreaterThanInt ����������:
  * True - ���� Value ������ Min
  * False - ���� Value ������ ��� ����� Min, � ErrorMsg ������������ ��������������� ��������� }

function IsGreaterThanInt(const FieldName: String; const Value: Integer;
  const Min: Integer; var ErrorMsg: String): Boolean;
begin
  Result := (Value > Min);
  if not Result then
    ErrorMsg := ErrorMsg + '�������� ���� "' + FieldName + '" ������ ���� ������ '
      + IntToStr(Min) + '.' + sLineBreak;
end;

{ TryStrToGreaterThanInt ����������:
  * True - ���� Value - ����� �����, ��� ������ Min � ���������� � ResulValue ��� �����
  * False - ���� Value: ���������� ������������� � ����� �����
    � ��� ������ ��� ����� Min. � ���� ������ � ResultValue ������������� 0,
    � � ErrorMsg ������������ ��������������� ��������� }

function TryStrToGreaterThanInt(const FieldName: String; const Value: String;
  const Min: Integer; var ErrorMsg: String; var ResultValue: Integer): Boolean;
begin
  if TryStrToIntMsg(FieldName, Value, ErrorMsg, ResultValue) then
    Result := IsGreaterThanInt(FieldName, ResultValue, Min, ErrorMsg)
  else
    Result := False;
end;

{ IsGreaterThanOrEqualInt ����������:
  * True - ���� Value ������ ��� ����� Min
  * False - ���� Value ������ Min, � ErrorMsg ������������ ��������������� ��������� }

function IsGreaterThanOrEqualInt(const FieldName: String; const Value: Integer;
  const Min: Integer; var ErrorMsg: String): Boolean;
begin
  Result := (Value >= Min);
  if not Result then
    ErrorMsg := ErrorMsg + '�������� ���� "' + FieldName + '" ������ ���� ������ ��� ����� '
      + IntToStr(Min) + '.' + sLineBreak;
end;

{ TryStrToGreaterThanOrEqualInt ����������:
  * True - ���� Value - ����� �����, ��� ������ ��� ����� Min � ���������� � ResulValue ��� �����
  * False - ���� Value: ���������� ������������� � ����� �����
    � ��� ������ Min. � ���� ������ � ResultValue ������������� 0,
    � � ErrorMsg ������������ ��������������� ��������� }

function TryStrToGreaterThanOrEqualInt(const FieldName: String; const Value: String;
  const Min: Integer; var ErrorMsg: String; var ResultValue: Integer): Boolean;
begin
  if TryStrToIntMsg(FieldName, Value, ErrorMsg, ResultValue) then
    Result := IsGreaterThanOrEqualInt(FieldName, ResultValue, Min, ErrorMsg)
  else
    Result := False;
end;

{ IsLessThanInt ����������:
  * True - ���� Value ������ Max
  * False - ���� Value ������ ��� ����� Max, � ErrorMsg ������������ ��������������� ��������� }

function IsLessThanInt(const FieldName: String; const Value: Integer;
  const Max: Integer; var ErrorMsg: String): Boolean;
begin
  Result := (Value < Max);
  if not Result then
    ErrorMsg := ErrorMsg + '�������� ���� "' + FieldName + '" ������ ���� ������ '
      + IntToStr(Max) + '.' + sLineBreak;
end;

{ TryStrToLessThanInt ����������:
  * True - ���� Value - ����� �����, ��� ������ Max � ���������� � ResulValue ��� �����
  * False - ���� Value: ���������� ������������� � ����� �����
    � ��� ������ ��� ����� Max. � ���� ������ � ResultValue ������������� 0,
    � � ErrorMsg ������������ ��������������� ��������� }

function TryStrToLessThanInt(const FieldName: String; const Value: String;
  const Max: Integer; var ErrorMsg: String; var ResultValue: Integer): Boolean;
begin
  if TryStrToIntMsg(FieldName, Value, ErrorMsg, ResultValue) then
    Result := IsLessThanInt(FieldName, ResultValue, Max, ErrorMsg)
  else
    Result := False;
end;

{ IsLessThanOrEqualInt ����������:
  * True - ���� Value ������ ��� ����� Max
  * False - ���� Value ������ Max, � ErrorMsg ������������ ��������������� ��������� }

function IsLessThanOrEqualInt(const FieldName: String; const Value: Integer;
  const Max: Integer; var ErrorMsg: String): Boolean;
begin
  Result := (Value <= Max);
  if not Result then
    ErrorMsg := ErrorMsg + '�������� ���� "' + FieldName + '" ������ ���� ������ ��� ����� '
      + IntToStr(Max) + '.' + sLineBreak;
end;

{ TryStrToLessThanOrEqualInt ����������:
  * True - ���� Value - ����� �����, ��� ������ ��� ����� Max � ���������� � ResulValue ��� �����
  * False - ���� Value: ���������� ������������� � ����� �����
    � ��� ������ Max. � ���� ������ � ResultValue ������������� 0,
    � � ErrorMsg ������������ ��������������� ��������� }

function TryStrToLessThanOrEqualInt(const FieldName: String; const Value: String;
  const Max: Integer; var ErrorMsg: String; var ResultValue: Integer): Boolean;
begin
  if TryStrToIntMsg(FieldName, Value, ErrorMsg, ResultValue) then
    Result := IsLessThanOrEqualInt(FieldName, ResultValue, Max, ErrorMsg)
  else
    Result := False;
end;

{ IsBetweenStr ����������:
  * True - ���� ����� ������ Str � �������� �� Min �� Max (�������
    ��� �������, ���� BorderIncluded ���������� � True
  * False - ���� ����� ������ Str �� ������ � �������� �� Min �� Max,
    � � ErrorMsg ������������ ��������������� ��������� }

function IsBetweenStr(const FieldName: String; const Str: String;
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

{ IsGreaterThanStr ����������:
  * True - ���� ����� ������ Str ������ Min
  * False - ���� ����� ������ Str ������ ��� ����� Min,
    � ErrorMsg ������������ ��������������� ��������� }

function IsGreaterThanStr(const FieldName: String; const Str: String;
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

{ IsGreaterThanOrEqualStr ����������:
  * True - ���� ����� ������ Str ������ ��� ����� Min
  * False - ���� ����� ������ Str ������ Min,
    � ErrorMsg ������������ ��������������� ��������� }

function IsGreaterThanOrEqualStr(const FieldName: String; const Str: String;
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

{ IsLessThanStr ����������:
  * True - ���� ����� ������ Str ������ Max
  * False - ���� ����� ������ Str ������ ��� ����� Max,
    � ErrorMsg ������������ ��������������� ��������� }

function IsLessThanStr(const FieldName: String; const Str: String;
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

{ IsLessThanOrEqualStr ����������:
  * True - ���� ����� ������ Str ������ ��� ����� Max
  * False - ���� ����� ������ Str ������ Max,
    � ErrorMsg ������������ ��������������� ��������� }

function IsLessThanOrEqualStr(const FieldName: String; const Str: String;
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
