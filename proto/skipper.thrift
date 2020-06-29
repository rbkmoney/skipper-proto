namespace java com.rbkmoney.damsel.skipper
namespace erlang skipper

include "base.thrift"

typedef base.ID ChargebackID

typedef base.ID CrmTicketID

struct ChargebackGeneralData {
    1: required base.Timestamp     pretension_date
    2: required base.ID            acquirer_id
    3: required base.Timestamp     operation_date
    4: required base.ID            invoice_id
    5: required base.ID            payment_id
    6: optional string             rrn
    7: optional string             masked_pan
    8: required base.Amount        amount
    9: required base.Currency      currency
    10: optional string            shop_url
    11: optional string            patry_email
    12: optional string            contact_email
    13: required base.ID           shop_id
    14: optional ChargebackReason  chargeback_reason
}

struct ChargebackData {
    1: required ChargebackGeneralData  general_data
    2: required list<StatusChange>     status_shanges
    3: optional list<Comment>          comments
    4: required HoldStatus             hold_status
}

struct ChargebackReason {
    1: optional base.ID            code
    2: required ChargebackCategory category
}

enum ChargebackCategory {
    fraud
    dispute
    authorisation
    processing_error
}

struct HoldStatus {
    1: optional bool                will_hold_from_merchant
    2: optional bool                was_hold_from_merchant
    3: optional bool                hold_from_us
}

struct StatusChange {
    1: required ChargebackStep      step
    2: required ChargebackStatus    status
    3: optional base.Timestamp      created_at
    4: optional Comment             comment
    5: optional base.Timestamp      date_of_decision
}

enum ChargebackStep {
    chargeback
    pre_arbitration
    arbitration
}

enum ChargebackStatus {
    pending
    accepted
    rejected
    cancelled
}

enum CommentOwnerType {
    merchant
    bank
    processing
}

struct CrmTicket {
    1: required CrmTicketID ticket_id
    2: optional CrmTicketInfo ticket_info
}

struct CrmTicketInfo {
    1: string comment
    2: string label
    3: string ticket_state
}

struct Comment {
    1: required string              message
    2: optional base.Timestamp      created_at
    3: required CommentOwnerType    comment_owner_type
    4: required string              comment_owner_name
}

exception ChargebackCreationException {}

/** Service for work with chargebacks */
service Skipper {

    ChargebackID RetrievalRequest(1: ChargebackGeneralData creation_data) throws (1: ChargebackCreationException ex1)

    ChargebackID CreateChargeback(1: ChargebackGeneralData creation_data) throws (1: ChargebackCreationException ex1)

    void ChangeStatus(base.ID invoice_id, base.ID payment_id, StatusChange status_change)

    void SetHoldStatus(base.ID invoice_id, base.ID payment_id, HoldStatus hold_status)

    void AddComment(base.ID invoice_id, base.ID payment_id, Comment comment)

    ChargebackData getChargeback(base.ID invoice_id, base.ID payment_id)

    list<ChargebackData> getChargebacksByStep(ChargebackStep step, ChargebackStatus status)

    list<ChargebackData> getChargebacksByDate(base.Timestamp date_from, base.Timestamp date_to)

    list<ChargebackData> getChargebacksByAcquirerId(string acquirer_id, list<ChargebackStatus> statuses)

    CrmTicketID CreateCrmTicket(ChargebackID chargeback_id, CrmTicketInfo ticket_info)

    CrmTicket GetCrmTicketById(ChargebackID chargeback_id)

}

