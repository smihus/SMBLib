unit SMB.Controller;

interface

uses
  Vcl.Forms, SMB.Model;
type
  TController = class
  private
    FForm: TForm;
    FModel: TModel;
  public
    constructor Create(Form: TForm; Model: TModel);
    property Form: TForm read FForm;
    property Model: TModel read FModel;
  end;
implementation

{ TController }

constructor TController.Create(Form: TForm; Model: TModel);
begin
  FForm   := Form;
  FModel  := Model;
end;

end.
