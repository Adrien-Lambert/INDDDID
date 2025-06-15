unit u_objet_TVetHospiAdmixture;

interface
uses
	System.JSON,
     IBQuery,
     IBDatabase,
     System.SysUtils;

type
     /// <summary>
     /// Exception de la classe EVetHospiAdmixture
     /// </summary>
     EVetHospiAdmixture = class(Exception);

     /// <summary>
     /// Stocke les informations des compléments de perfusions de VetHospi
     /// </summary>
     TVetHospiAdmixture = class
          private
            fUuid: string;
            fActBillable: boolean;
            fActExternalId: string;
            fActIdRaf: Integer;
            fName: String;
            fUnit: String;
            fQuantity: double;
            fPerDay: boolean;
            fLastModified : TDateTime;

          public

            /// <summary>
            /// Donne l'identifiant Vethospi
            /// </summary>
            property Uuid: String read fUuid;

            /// <summary>
            /// Indique si l'acte est facturable
            /// </summary>
            property ActBillable: Boolean read fActBillable;

            /// <summary>
            /// Identifiant VP de l'acte
            /// </summary>
            property ActExternalId: String read fActExternalId;

            /// <summary>
            /// Identifiant du reste a facturer lié à l'acte
            /// </summary>
            property ActIdRaf: Integer read fActIdRaf;

            /// <summary>
            /// Nom du complément (glucose, potassium...)
            /// </summary>
            property Name: String read fName;

            /// <summary>
            /// Unité associée au complément (mL, mg...)
            /// </summary>
            property UnitVh: String read fUnit;

            /// <summary>
            /// La quantité de complément dans l'unité précisée
            /// </summary>
            property Quantity: double read fQuantity;

            /// <summary>
            /// Si le complément est injecté qu'une seule fois par jour
            /// </summary>
            property PerDay: boolean read fPerDay;

            /// <summary>
            /// Donne la date de dernière modification
            /// </summary>
            property LastModified: TDateTime read fLastModified;

            /// <summary>
            /// Contructeur par defaut
            /// </summary>
            constructor Create();

            /// <summary>
            /// Vide l'objet complément
            /// </summary>
            procedure Clear;

            /// <summary>
            // Charge depuis le JSonObject de la table VetHospi
            /// </summary>
			/// <param name="aJSon">JSon source</param>
            procedure LoadFromJSon(aJson : TJsonObject);

            /// <summary>
            /// Si le complément existe en base de données
            /// </summary>
            function IsAdmixtureExistsInBd: Boolean;

            /// <summary>
            /// Donne l'id du RAF de l'acte
            /// </summary>
            function GetResteAFacturerActIdFromDatabase(): Integer;

            /// <summary>
            /// Set l'id du RAF de l'acte
            /// </summary>
            function SetResteAFacturerActIdInDatabase(aResteAFacturerId : Integer): Boolean;

            /// <summary>
            /// Supprimes le reste a facturer lié à l'acte de base s'il existe
            /// </summary>
            function DeleteActeResteAFacturer() : Boolean;

            /// <summary>
            // Gestion dans la base de donnees
            /// </summary>
            function ManageInDatabase(aInfusionGuid : String) : Boolean;
     end;

implementation

uses
     u_common_functions_json,
     Data.DB,
	u_idm,
     u_common_functions_VetHospi,
     u_objet_TVetHospiResteAFacturerInfusion;

constructor TVetHospiAdmixture.Create;
begin
     Clear;
end;

procedure TVetHospiAdmixture.Clear();
begin
    fUuid           := '';
    fActBillable    := False;
    fActExternalId  := '';
    fActIdRaf       := 0;
    fName           := '';
    fUnit           := '';
    fQuantity       := 0;
    fPerDay         := False;
    fLastModified   := 0;
end;

procedure TVetHospiAdmixture.LoadFromJson(aJson : TJsonObject);
var
     fStringLastModified : String;
begin
     try
     	fUuid := aJson.GetValue<String>('id');
          fActBillable := aJson.getValue<Boolean>('billable');
          fPerDay := aJson.getValue<Boolean>('per_day');
          fActExternalId := aJson.getValue<String>('act_external_id');
          fName := aJson.getValue<String>('name');
          fUnit := aJson.getValue<String>('unit');
          fQuantity := aJson.getValue<double>('quantity');

          if aJson.TryGetValue<String>('last_modified', fStringLastModified) then
          begin
          	fLastModified := doVetHospi_VhStringDateTimeToVpDateTime(fStringLastModified);
          end;
     except
          on E: Exception do
          begin
          	raise EVetHospiAdmixture.Create('Un problème a eu lieu lors de la récupération du JSON du complément : ' + E.Message);
          end;
     end;
end;
end.