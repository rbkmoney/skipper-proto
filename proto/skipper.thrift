namespace java com.rbkmoney.damsel.skipper
namespace erlang skipper

include "base.thrift"

typedef base.ID ChargebackID

typedef base.ID CrmTicket

struct ChargebackCreationData {
    1: required base.ID    invoice_id
    2: required base.ID    payment_id
}

struct RefundInfo {
    1: required base.ID id
}

struct PaymentInfo {
    1: required base.ID      id
    2: required base.Amount  amount
    3: optional RefundInfo   refund_info
}

enum CommentOwnerType {
    INNER
    OUTER
}

struct Comment {
    1: required base.ID             id
    2: required base.Timestamp      created_at
    3: required string              message
    4: required CommentOwnerType    comment_owner_type
    5: required string              comment_owner_name
}

struct ChargebackInfo {
    1: required base.ID        changeback_id
    2: required PaymentInfo    payment_info
    3: required list<Comment>  comments
}

exception ChargebackCreationException {}

/** Service for work with chargebacks */
service Skipper {

    /** The command creates a new chargeback */
    ChargebackID CreateChargeback(1: ChargebackCreationData creation_data) throws (1: ChargebackCreationException ex1)

    /** Get info about a chargeback by rrn */
    ChargebackInfo GetChargebackInfoByRrn(base.ID rrn)

    /** Get info about a chargeback by card number */
    list<ChargebackInfo> GetChargebackInfoByCard(base.CardNumber card_number)

    /** Get chargeback CRM ticket by ID */
    CrmTicket GetCrmTicketById(ChargebackID chargeback_id)

}

