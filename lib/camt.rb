require 'nokogiri'
require 'time'

require 'camt/version'
require 'camt/object_extension'
require 'camt/file'
require 'camt/parser'
require 'camt/statement'

module Camt

  # Define structs

  Message = Struct.new(:group_header, :statements)
  GroupHeader = Struct.new(:message_id, :created_at, :recipient, :pagination, :additional_info)

  Transaction = Struct.new(
    :execution_date,
    :effective_date,
    :transfer_type,
    :transferred_amount,
    :transaction_details
  )

  Reasons = {
    'EN' => {
      'AC01' => "Account identifier incorrect (i.e. invalid IBAN)",
      'AC04' => "Account closed",
      'AC06' => "Account blocked",
      'AG01' => "Direct debit forbidden on this account for regulatory reasons",
      'AG02' => "Operation/transaction code incorrect, invalid file format",
      'AM04' => "Insufficient funds",
      'AM05' => "Duplicate collection",
      'BE01' => "Debtor's name does not match with the account holder's name",
      'BE04' => "Creditor adress  missing or incorrect",
      'BE05' => "Creditor identifier incorrect",
      'FF01' => "Operation/transaction code incorrect, invalid file format",
      'FF05' => "Operation/transaction type incorrect",
      'FOCR' => "Returned after cancellation request of account holder",
      'MD01' => "No Mandate",
      'MD02' => "Mandate data missing or incorrect",
      'MD06' => "Returned after request of account holder",
      'MD07' => "Debtor deceased",
      'MS02' => "Refusal by the Debtor",
      'MS03' => "Reason not specified",
      'RC01' => "Bank identifier incorrect (i.e. invalid BIC)",
      'RR01' => "Regulatory Reason",
      'RR02' => "Regulatory Reason",
      'RR03' => "Regulatory Reason",
      'RR04' => "Regulatory Reason",
      'SL01' => "Specific Service offered by the Debtor Bank",
      'CNOR' => "Creditor bank is not registered under this BIC in the CSM",
      'DNOR' => "Debtor bank is not registered under this BIC in the CSM",
      'TM01' => "File received after Cut-off Time",
    },
    'NL' => {
      'AC01' => "Rekeningnummer incorrect",
      'AC04' => "Rekeningnummer gesloten",
      'AC06' => "Rekeningnummer geblokkeerd",
      'AC13' => "Debiteur rekening is klant rekening",
      'AG01' => "Transactie niet toegestaan",
      'AG02' => "Transactiecode incorrect, ongeldig bestandsformaat",
      'AM04' => "Onvoldoende saldo",
      'AM05' => "Dubbel betaald",
      'BE01' => "Debiteur naam en rekeningnummer komen niet overeen",
      'BE04' => "Adres crediteur ontbreekt of incorrect",
      'BE05' => "Identificatie van de crediteur is incorrect",
      'FF01' => "Transactie code incorrect",
      'FF05' => "Incasso type incorrect",
      'FOCR' => "Terugboeking na annuleringsverzoek",
      'MD01' => "Geen machtiging verstrekt",
      'MD02' => "Verplichte informatie over machtiging ontbreekt of incorrect",
      'MD06' => "Terugboeking op verzoek van klant",
      'MD07' => "Klant overleden",
      'MS02' => "Onbekende reden klant",
      'MS03' => "Onbekende reden bank",
      'RC01' => "BIC incorrect",
      'RR01' => "Wet of regelgeving",
      'RR02' => "Voor wet of regelgeving benodigde naam en/of adres van de debiteur is onvolledig of ontbreekt",
      'RR03' => "Voor wet of regelgeving benodigde naam en/of adres van de crediteur ontbreekt",
      'RR04' => "Wet of regelgeving",
      'SL01' => "Specifieke dienstverlening bank (bv selectieve incassoblokkade)",
      'CNOR' => "Bank van de crediteur is niet bekend onder deze BIC",
      'DNOR' => "Bank van de debiteur is niet bekend onder deze BIC",
      'TM01' => "Bestand aangeleverd na cut-off tijd (uiterste aanlevertijdstip)"
    }
  }

end
