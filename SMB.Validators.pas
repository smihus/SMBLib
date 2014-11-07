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

{ HasStrValue возвращает:
  * True - если Value - не пустая строка.
  * False - если Value - пуста ястрока, то в ErrorMsg дописывается
    предупреждающее сообщение }

function HasStrValue(const FieldName: String; const Value: String; var ErrorMsg: String): Boolean;
begin
  Result := (Trim(Value) <> '');
  if not Result then
    ErrorMsg := ErrorMsg + 'Значение поля "' + FieldName + '" должно быть заполнено.' + sLineBreak;
end;

{ KeyPressFloat разрешает пользователю вводить только цифры, разделитель между
  целой и дробной частью (с учетом региональных настроек), а также клавишу TAB,
  Enter, Delete и Backspace.
  Процедуру необходимо вызвать в обработчике события OnKeyPress нужного компонета
  и передать соответствующий стандартный параметр. }

procedure KeyPressFloat(var Key: Char);
begin
  if not CharInSet(Key, TFloatInputKeysSet) then
    Key := #0
  else if CharInSet(Key, [',', '.']) then
    Key := FormatSettings.DecimalSeparator
end;

{ KeyPressInt разрешает пользователю вводить только цифры, а также клавишу TAB,
  Enter, Delete и Backspace.
  Процедуру необходимо вызвать в обработчике события OnKeyPress нужного компонета
  и передать соответствующий стандартный параметр. }

procedure KeyPressInt(var Key: Char);
begin
  if not CharInSet(Key, TIntInputKeysSet) then Key := #0
end;

{ TryStrToFloatMsg возвращает:
  * True - если Value - число с плавоющей точкой и записывает в ResulValue это число.
  * False - если Value невозможно преобразовать в число с плавающей точкой,
    В этом случае в ResultValue присваивается 0, а в ErrorMsg дописывается
    предупреждающее сообщение }

function TryStrToFloatMsg(const FieldName: String; const Value: String;
  var ErrorMsg: String; var ResultValue: Extended): Boolean;
begin
  Result := TryStrToFloat(Value, ResultValue);
  if not Result then
  begin
    ErrorMsg := ErrorMsg + 'Значение поля "' + FieldName
      + '" должно быть числом.' + sLineBreak;
    ResultValue := -1;
  end;
end;

{ TryStrToIntMsg возвращает:
  * True - если Value - целое число и записывает в ResulValue это число.
  * False - если Value невозможно преобразовать в целое число,
    В этом случае в ResultValue присваивается 0, а в ErrorMsg дописывается
    предупреждающее сообщение }

function TryStrToIntMsg(const FieldName: String; const Value: String;
  var ErrorMsg: String; var ResultValue: Integer): Boolean;
begin
  Result := TryStrToInt(Value, ResultValue);
  if not Result then
  begin
    ErrorMsg := ErrorMsg + 'Значение поля "' + FieldName
      + '" должно быть целым числом.' + sLineBreak;
    ResultValue := -1;
  end;
end;

{ IsBetween возвращает:
  * True - если Value в пределах от Min до Max (включая
    эти границы, если BorderIncluded установлен в True
  * False - если Value не входит в диапазон от Min до Max,
    а в ErrorMsg дописывается предупреждающее сообщение }

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
      ErrorMsg := ErrorMsg + 'Значение поля "' + FieldName
        + '" должно быть в пределах от '
        + IntToStr(Min) + ' до ' + IntToStr(Max) + ' включительно.' + sLineBreak
    else
      ErrorMsg := ErrorMsg + 'Значение поля "' + FieldName
        + '" должно быть в пределах от '
        + IntToStr(Min) + ' до ' + IntToStr(Max) + '.' + sLineBreak;
end;

{ TryStrToBetweenInt возвращает:
  * True - если Value - целое число в пределах от Min до Max (включая
    эти границы, если BorderIncluded установлен в True и записывает в ResulValue это число
  * False - если Value: невозможно преобразовать в целое число,
    не входит в диапазон от Min до Max. В этом случае в ResultValue присваивается 0,
    а в ErrorMsg дописывается предупреждающее сообщение }

function TryStrToBetween(const FieldName: String; const Value: String;
  const Min: Integer; const Max: Integer; var ErrorMsg: String;
  var ResultValue: Integer; const BorderIncluded: Boolean = False): Boolean; overload;
begin
  if TryStrToIntMsg(FieldName, Value, ErrorMsg, ResultValue) then
    Result := IsBetween(FieldName, ResultValue, Min, Max, ErrorMsg, BorderIncluded)
  else
    Result := False;
end;

{ IsBetweenFloat возвращает:
  * True - если Value в пределах от Min до Max (включая
    эти границы, если BorderIncluded установлен в True
  * False - если Value не входит в диапазон от Min до Max,
    а в ErrorMsg дописывается предупреждающее сообщение }

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
      ErrorMsg := ErrorMsg + 'Значение поля "' + FieldName
        + '" должно быть в пределах от '
        + FloatToStr(Min) + ' до ' + FloatToStr(Max) + ' включительно.' + sLineBreak
    else
      ErrorMsg := ErrorMsg + 'Значение поля "' + FieldName
        + '" должно быть в пределах от '
        + FloatToStr(Min) + ' до ' + FloatToStr(Max) + '.' + sLineBreak;
end;

{ TryStrToBetweenFloat возвращает:
  * True - если Value - число с плавоющей точкой в пределах от Min до Max (включая
    эти границы, если BorderIncluded установлен в True и записывает в ResulValue это число
  * False - если Value: невозможно преобразовать в число с плавающей точкой,
    не входит в диапазон от Min до Max. В этом случае в ResultValue присваивается 0,
    а в ErrorMsg дописывается предупреждающее сообщение }

function TryStrToBetween(const FieldName: String; const Value: String;
  const Min: Extended; const Max: Extended; var ErrorMsg: String;
  var ResultValue: Extended; const BorderIncluded: Boolean = False): Boolean; overload;
begin
  if TryStrToFloatMsg(FieldName, Value, ErrorMsg, ResultValue) then
    Result := IsBetween(FieldName, ResultValue, Min, Max, ErrorMsg, BorderIncluded)
  else
    Result := False;
end;

{ IsGreaterThanFloat возвращает:
  * True - если Value больше Min
  * False - если Value меньше или равно Min,
    в ErrorMsg дописывается предупреждающее сообщение }

function IsGreaterThanFloat(const FieldName: String; const Value: Extended;
  const Min: Extended; var ErrorMsg: String): Boolean;
begin
  Result := (Value > Min);
  if not Result then
    ErrorMsg := ErrorMsg + 'Значение поля "' + FieldName + '" должно быть больше '
      + FloatToStr(Min) + '.' + sLineBreak;
end;

{ TryStrToGreaterThanFloat возвращает:
  * True - если Value - число с плавоющей точкой больше Min и записывает в ResulValue это число
  * False - если Value: невозможно преобразовать в число с плавающей точкой,
    и оно меньше или равно Min. В этом случае в ResultValue присваивается 0,
    а в ErrorMsg дописывается предупреждающее сообщение }

function TryStrToGreaterThanFloat(const FieldName: String; const Value: String;
  const Min: Extended; var ErrorMsg: String; var ResultValue: Extended): Boolean;
begin
  if TryStrToFloatMsg(FieldName, Value, ErrorMsg, ResultValue) then
    Result := IsGreaterThanFloat(FieldName, ResultValue, Min, ErrorMsg)
  else
    Result := False;
end;

{ IsGreaterThanOrEqualFloat возвращает:
  * True - если Value больше или равно Min
  * False - если Value меньше Min, в ErrorMsg дописывается предупреждающее сообщение }

function IsGreaterThanOrEqualFloat(const FieldName: String; const Value: Extended;
  const Min: Extended; var ErrorMsg: String): Boolean;
begin
  Result := (Value >= Min);
  if not Result then
    ErrorMsg := ErrorMsg + 'Значение поля "' + FieldName + '" должно быть больше или равно '
      + FloatToStr(Min) + '.' + sLineBreak;
end;

{ TryStrToGreaterThanOrEqualFloat возвращает:
  * True - если Value - число с плавоющей точкой больше или равно Min и записывает в ResulValue это число
  * False - если Value: невозможно преобразовать в число с плавающей точкой,
    и оно меньше Min. В этом случае в ResultValue присваивается 0,
    а в ErrorMsg дописывается предупреждающее сообщение }

function TryStrToGreaterThanOrEqualFloat(const FieldName: String; const Value: String;
  const Min: Extended; var ErrorMsg: String; var ResultValue: Extended): Boolean;
begin
  if TryStrToFloatMsg(FieldName, Value, ErrorMsg, ResultValue) then
    Result := IsGreaterThanOrEqualFloat(FieldName, ResultValue, Min, ErrorMsg)
  else
    Result := False;
end;

{ IsLessThanFloat возвращает:
  * True - если Value меньше Max
  * False - если Value больше или равно Max,
    в ErrorMsg дописывается предупреждающее сообщение }

function IsLessThanFloat(const FieldName: String; const Value: Extended;
  const Max: Extended; var ErrorMsg: String): Boolean;
begin
  Result := (Value < Max);
  if not Result then
    ErrorMsg := ErrorMsg + 'Значение поля "' + FieldName + '" должно быть меньше '
      + FloatToStr(Max) + '.' + sLineBreak;
end;

{ TryStrToLessThanFloat возвращает:
  * True - если Value - число с плавоющей точкой меньше Max и записывает в ResulValue это число
  * False - если Value: невозможно преобразовать в число с плавающей точкой,
    и оно больше или равно Max. В этом случае в ResultValue присваивается 0,
    а в ErrorMsg дописывается предупреждающее сообщение }

function TryStrToLessThanFloat(const FieldName: String; const Value: String;
  const Max: Extended; var ErrorMsg: String; var ResultValue: Extended): Boolean;
begin
  if TryStrToFloatMsg(FieldName, Value, ErrorMsg, ResultValue) then
    Result := IsLessThanFloat(FieldName, ResultValue, Max, ErrorMsg)
  else
    Result := False;
end;

{ IsLessThanOrEqualFloat возвращает:
  * True - если Value меньше или равно Max
  * False - если Value больше Max,
    в ErrorMsg дописывается предупреждающее сообщение }

function IsLessThanOrEqualFloat(const FieldName: String; const Value: Extended;
  const Max: Extended; var ErrorMsg: String): Boolean;
begin
  Result := (Value <= Max);
  if not Result then
    ErrorMsg := ErrorMsg + 'Значение поля "' + FieldName + '" должно быть меньше или равно '
      + FloatToStr(Max) + '.' + sLineBreak;
end;

{ TryStrToLessThanOrEqualFloat возвращает:
  * True - если Value - число с плавоющей точкой меньше или равно Max и записывает в ResulValue это число
  * False - если Value: невозможно преобразовать в число с плавающей точкой,
    и оно больше Max. В этом случае в ResultValue присваивается 0,
    а в ErrorMsg дописывается предупреждающее сообщение }

function TryStrToLessThanOrEqualFloat(const FieldName: String; const Value: String;
  const Max: Extended; var ErrorMsg: String; var ResultValue: Extended): Boolean;
begin
  if TryStrToFloatMsg(FieldName, Value, ErrorMsg, ResultValue) then
    Result := IsLessThanFloat(FieldName, ResultValue, Max, ErrorMsg)
  else
    Result := False;
end;

{ IsGreaterThanInt возвращает:
  * True - если Value больше Min
  * False - если Value меньше или равно Min, в ErrorMsg дописывается предупреждающее сообщение }

function IsGreaterThanInt(const FieldName: String; const Value: Integer;
  const Min: Integer; var ErrorMsg: String): Boolean;
begin
  Result := (Value > Min);
  if not Result then
    ErrorMsg := ErrorMsg + 'Значение поля "' + FieldName + '" должно быть больше '
      + IntToStr(Min) + '.' + sLineBreak;
end;

{ TryStrToGreaterThanInt возвращает:
  * True - если Value - целое число, оно больше Min и записывает в ResulValue это число
  * False - если Value: невозможно преобразовать в целое число
    и оно меньше или равно Min. В этом случае в ResultValue присваивается 0,
    а в ErrorMsg дописывается предупреждающее сообщение }

function TryStrToGreaterThanInt(const FieldName: String; const Value: String;
  const Min: Integer; var ErrorMsg: String; var ResultValue: Integer): Boolean;
begin
  if TryStrToIntMsg(FieldName, Value, ErrorMsg, ResultValue) then
    Result := IsGreaterThanInt(FieldName, ResultValue, Min, ErrorMsg)
  else
    Result := False;
end;

{ IsGreaterThanOrEqualInt возвращает:
  * True - если Value больше или равно Min
  * False - если Value меньше Min, в ErrorMsg дописывается предупреждающее сообщение }

function IsGreaterThanOrEqualInt(const FieldName: String; const Value: Integer;
  const Min: Integer; var ErrorMsg: String): Boolean;
begin
  Result := (Value >= Min);
  if not Result then
    ErrorMsg := ErrorMsg + 'Значение поля "' + FieldName + '" должно быть больше или равно '
      + IntToStr(Min) + '.' + sLineBreak;
end;

{ TryStrToGreaterThanOrEqualInt возвращает:
  * True - если Value - целое число, оно больше или равно Min и записывает в ResulValue это число
  * False - если Value: невозможно преобразовать в целое число
    и оно меньше Min. В этом случае в ResultValue присваивается 0,
    а в ErrorMsg дописывается предупреждающее сообщение }

function TryStrToGreaterThanOrEqualInt(const FieldName: String; const Value: String;
  const Min: Integer; var ErrorMsg: String; var ResultValue: Integer): Boolean;
begin
  if TryStrToIntMsg(FieldName, Value, ErrorMsg, ResultValue) then
    Result := IsGreaterThanOrEqualInt(FieldName, ResultValue, Min, ErrorMsg)
  else
    Result := False;
end;

{ IsLessThanInt возвращает:
  * True - если Value меньше Max
  * False - если Value больше или равно Max, в ErrorMsg дописывается предупреждающее сообщение }

function IsLessThanInt(const FieldName: String; const Value: Integer;
  const Max: Integer; var ErrorMsg: String): Boolean;
begin
  Result := (Value < Max);
  if not Result then
    ErrorMsg := ErrorMsg + 'Значение поля "' + FieldName + '" должно быть меньше '
      + IntToStr(Max) + '.' + sLineBreak;
end;

{ TryStrToLessThanInt возвращает:
  * True - если Value - целое число, оно меньше Max и записывает в ResulValue это число
  * False - если Value: невозможно преобразовать в целое число
    и оно больше или равно Max. В этом случае в ResultValue присваивается 0,
    а в ErrorMsg дописывается предупреждающее сообщение }

function TryStrToLessThanInt(const FieldName: String; const Value: String;
  const Max: Integer; var ErrorMsg: String; var ResultValue: Integer): Boolean;
begin
  if TryStrToIntMsg(FieldName, Value, ErrorMsg, ResultValue) then
    Result := IsLessThanInt(FieldName, ResultValue, Max, ErrorMsg)
  else
    Result := False;
end;

{ IsLessThanOrEqualInt возвращает:
  * True - если Value меньше или равно Max
  * False - если Value больше Max, в ErrorMsg дописывается предупреждающее сообщение }

function IsLessThanOrEqualInt(const FieldName: String; const Value: Integer;
  const Max: Integer; var ErrorMsg: String): Boolean;
begin
  Result := (Value <= Max);
  if not Result then
    ErrorMsg := ErrorMsg + 'Значение поля "' + FieldName + '" должно быть меньше или равно '
      + IntToStr(Max) + '.' + sLineBreak;
end;

{ TryStrToLessThanOrEqualInt возвращает:
  * True - если Value - целое число, оно меньше или равно Max и записывает в ResulValue это число
  * False - если Value: невозможно преобразовать в целое число
    и оно больше Max. В этом случае в ResultValue присваивается 0,
    а в ErrorMsg дописывается предупреждающее сообщение }

function TryStrToLessThanOrEqualInt(const FieldName: String; const Value: String;
  const Max: Integer; var ErrorMsg: String; var ResultValue: Integer): Boolean;
begin
  if TryStrToIntMsg(FieldName, Value, ErrorMsg, ResultValue) then
    Result := IsLessThanOrEqualInt(FieldName, ResultValue, Max, ErrorMsg)
  else
    Result := False;
end;

{ IsBetweenStr возвращает:
  * True - если длина строки Str в пределах от Min до Max (включая
    эти границы, если BorderIncluded установлен в True
  * False - если длина строки Str не входит в диапазон от Min до Max,
    а в ErrorMsg дописывается предупреждающее сообщение }

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
      ErrorMsg := ErrorMsg + 'Длина значения поля "' + FieldName
        + '" должна быть в пределах от '
        + IntToStr(Min) + ' до ' + IntToStr(Max) + ' включительно.' + sLineBreak
    else
      ErrorMsg := ErrorMsg + 'Длина значения поля "' + FieldName
        + '" должна быть в пределах от '
        + IntToStr(Min) + ' до ' + IntToStr(Max) + '.' + sLineBreak;
end;

{ IsGreaterThanStr возвращает:
  * True - если длина строки Str больше Min
  * False - если длина строки Str меньше или равно Min,
    в ErrorMsg дописывается предупреждающее сообщение }

function IsGreaterThanStr(const FieldName: String; const Str: String;
  const Min: Integer; var ErrorMsg: String): Boolean;
var
  StrLen: Integer;
begin
  StrLen := Length(Str);
  Result := (StrLen > Min);
  if not Result then
    ErrorMsg := ErrorMsg + 'Длина значения поля "' + FieldName + '" должна быть больше '
      + IntToStr(Min) + '.' + sLineBreak;
end;

{ IsGreaterThanOrEqualStr возвращает:
  * True - если длина строки Str больше или равно Min
  * False - если длина строки Str меньше Min,
    в ErrorMsg дописывается предупреждающее сообщение }

function IsGreaterThanOrEqualStr(const FieldName: String; const Str: String;
  const Min: Integer; var ErrorMsg: String): Boolean;
var
  StrLen: Integer;
begin
  StrLen := Length(Str);
  Result := (StrLen >= Min);
  if not Result then
    ErrorMsg := ErrorMsg + 'Длина значения поля "' + FieldName + '" должна быть больше или равна '
      + IntToStr(Min) + '.' + sLineBreak;
end;

{ IsLessThanStr возвращает:
  * True - если длина строки Str меньше Max
  * False - если длина строки Str больше или равно Max,
    в ErrorMsg дописывается предупреждающее сообщение }

function IsLessThanStr(const FieldName: String; const Str: String;
  const Max: Integer; var ErrorMsg: String): Boolean;
var
  StrLen: Integer;
begin
  StrLen := Length(Str);
  Result := (StrLen < Max);
  if not Result then
    ErrorMsg := ErrorMsg + 'Длина значения поля "' + FieldName + '" должна быть меньше '
      + IntToStr(Max) + '.' + sLineBreak;
end;

{ IsLessThanOrEqualStr возвращает:
  * True - если длина строки Str меньше или равно Max
  * False - если длина строки Str больше Max,
    в ErrorMsg дописывается предупреждающее сообщение }

function IsLessThanOrEqualStr(const FieldName: String; const Str: String;
  const Max: Integer; var ErrorMsg: String): Boolean;
var
  StrLen: Integer;
begin
  StrLen := Length(Str);
  Result := (StrLen <= Max);
  if not Result then
    ErrorMsg := ErrorMsg + 'Длина значения поля "' + FieldName + '" должна быть меньше или равна '
      + IntToStr(Max) + '.' + sLineBreak;
end;

end.
