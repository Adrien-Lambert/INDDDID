function TEngineVetHospi.doVetHospi_PostUpdateInvoices(var aMessageErreur : string) : Boolean;
var
     fJSON: TJSONArray;
     fInvoicableCareList : TObjectList<TVetHospiInvoicableCare>;
     mPreferenceVetHospi: TPreferenceVetHospi;
     fCodeReponse : Integer;
     fReponse: TJSONObject;
     fUrl : String;
     fMessageErreur : String;
begin
  Log.doBegin('TEngineVetHospi.doVetHospi_PostUpdateInvoices');
  Result := True;
  fInvoicableCareList := TObjectList<TVetHospiInvoicableCare>.Create();
  try
      try
      	mPreferenceVetHospi := Preference as TPreferenceVetHospi;
          fJSON := TJSONArray.Create;
          fMessageErreur := 'Impossible de préparer les données de lignes d''hospitalisation facturables. Assurez-vous que la base de données est à jour. : ';
          if not DoPreparePostUpdateInvoices(fJSON, fInvoicableCareList, fMessageErreur) then
            begin
                idm.MyShowMessage(fMessageErreur);
                exit;
            end;

          if fJSON.Count > 0 then
          begin
               TInterfaceVetHospi.doVetHospi_SendInvoiceUpdatesOfCares(
                    _VETHOSPI_URL_API_UPDATE_INVOICE,
                    mToken,
                    fJSON,
                    fCodeReponse,
                    aMessageErreur,
                    fReponse,
                    Log);
               Result := (fCodeReponse = 200) or (fCodeReponse = 201);

               if ((fCodeReponse <> 200) and (fCodeReponse <> 201) or not (fReponse <> nil)) then
                    begin
                         aMessageErreur := 'Impossible d''envoyer les mises à jour de facturation des lignes d''hospitalisation à Vet Hospi.';
                         Log.doTrace(aMessageErreur);
                         Result := False;
                         exit;
                    end
               else
               begin
                    // Bien reçu par VetHospi -> On passe tous la colonne SENT_TO_VH des objets care envoyés à true
                    TVetHospiInvoicableCare.SetCareSentToVH(fInvoicableCareList);
               end;
          end;

      except
           on E:Exception
           do begin
                aMessageErreur := E.Message;
                Result := False;
           end;
      end;
  finally
      Log.doEnd;
      FreeAndNil(fInvoicableCareList);
  end;
end;