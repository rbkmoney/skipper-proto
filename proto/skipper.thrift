namespace java com.rbkmoney.damsel.skipper
namespace erlang skipper

include "base.thrift"

typedef base.ID ChargebackID

struct ChargebackGeneralData {
    1: required base.Timestamp     pretension_date
    2: required base.ID            provider_id
    3: required base.Timestamp     operation_date
    4: required base.ID            invoice_id
    5: required base.ID            payment_id
    6: optional string             rrn
    7: optional string             masked_pan
    8: required base.Amount        amount
    9: required base.Currency      currency
    10: optional string            shop_url
    11: optional string            party_email
    12: optional string            contact_email
    13: required base.ID           shop_id
    14: optional ChargebackReason  chargeback_reason
}

struct ChargebackReason {
    1: optional base.ID            code
    2: required ChargebackCategory category
}

union ChargebackCategory {
    1: ChargebackCategoryFraud           fraud
    2: ChargebackCategoryDispute         dispute
    3: ChargebackCategoryAuthorisation   authorisation
    4: ChargebackCategoryProcessingError processing_error
}

struct ChargebackCategoryFraud           {}
struct ChargebackCategoryDispute         {}
struct ChargebackCategoryAuthorisation   {}
struct ChargebackCategoryProcessingError {}

union ChargebackStage {
    1: StageChargeback     chargeback
    2: StagePreArbitration pre_arbitration
    3: StageArbitration    arbitration
}

struct StageChargeback     {}
struct StagePreArbitration {}
struct StageArbitration    {}

union ChargebackStatus {
    1: ChargebackPending   pending
    2: ChargebackAccepted  accepted
    3: ChargebackRejected  rejected
    4: ChargebackCancelled cancelled
}

struct ChargebackPending   {}
struct ChargebackAccepted  {}
struct ChargebackRejected  {}
struct ChargebackCancelled {}


union ChargebackEvent {
    1: ChargebackCreateEvent           create_event
    2: ChargebackStatusChangeEvent     status_change_event
    3: ChargebackHoldStatusChangeEvent hold_status_change_event
}

struct ChargebackCreateEvent {
    1: required ChargebackGeneralData creation_data
}

struct ChargebackStatusChangeEvent {
    1: required base.ID            invoice_id
    2: required base.ID            payment_id
    3: required ChargebackStage     stage
    4: required ChargebackStatus    status
    5: optional base.Timestamp      created_at
    6: optional base.Timestamp      date_of_decision
}

struct ChargebackHoldStatusChangeEvent {
    1: required base.ID            invoice_id
    2: required base.ID            payment_id
    3: optional bool               will_hold_from_merchant
    4: optional bool               was_hold_from_merchant
    5: optional bool               hold_from_us
}

struct ChargebackData {
    1: required ChargebackID           id
    2: required list<ChargebackEvent>  events
}

exception ChargebackCreationException {}

/** Service for work with chargebacks */
service Skipper {

    void processChargebackData(1: ChargebackEvent event)

    ChargebackData getChargebackData(base.ID invoice_id, base.ID payment_id)

    list<ChargebackData> getChargebacksByStep(ChargebackStage step, ChargebackStatus status)

    list<ChargebackData> getChargebacksByDate(base.Timestamp date_from, base.Timestamp date_to)

    list<ChargebackData> getChargebacksByProviderId(string provider_id, list<ChargebackStatus> statuses)

}

