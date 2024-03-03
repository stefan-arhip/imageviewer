program ImageViewer;

uses
  Forms,
  _foto_ in '_foto_.pas' {foto_},
  _Despre_ in '_despre_.pas' {Despre_};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(Tfoto_, foto_);
  Application.CreateForm(TDespre_, Despre_);
  Application.Run;
end.
