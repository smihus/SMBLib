unit SMBFormFactory;

interface
uses
  Vcl.Forms, System.Classes, Data.Win.ADODB;
type
  TSMBFormFactory = class
  public
    function createForm(aName: String; aOwner: TComponent): TForm; virtual; abstract;
  end;

implementation

end.
