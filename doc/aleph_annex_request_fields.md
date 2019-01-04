Common fields for all types of item requests (both ILL and Aleph):

* transaction
* request_type
* delivery_type
* source
* author
* title
* pages
* bib_number
* article_title
* article_author
* isbn
* issn
* rush


Aleph only:

* enum_chron
* barcode
* adm_number
* item_sequence
* call_number
* send_to

ILL only:

* month
* issue
* username
* standard_number
* location
* transactionstatus
* volume
* systemid
* jtitle
* pieces
* year

Fields taken from the ILL requests and added to the API output for each request:

* description: concatenate pieces, volume, issue, month, year
* journal_title: jtitle
* ill_system_id: systemid
* ill_standard_number: standard_number

Fields from both modified for API output:

* isbn_issn: concatenate isbn, issn

Fields taken from Aleph only and added to the API output:

* description: in addition, add enum_chron
* barcode: barcode
* bib_number: bib_number
* adm_number: adm_number
* item_sequence: item_sequence
* call_number: call_number
* send_to: send_to