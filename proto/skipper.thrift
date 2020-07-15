namespace java com.rbkmoney.damsel.skipper
namespace erlang skipper

include "base.thrift"
include "chargeback.thrift"

typedef base.ID ChargebackID

struct ChargebackGeneralData {
    1: required base.Timestamp     pretension_date
    2: required base.ID            provider_id
    3: required base.Timestamp     operation_date
    4: required base.ID            invoice_id
    5: required base.ID            payment_id
    6: required base.ID            chargeback_id
    7: optional string             rrn
    8: optional string             masked_pan
    9: required base.Amount        levy_amount
    10: optional base.Amount       body_amount
    11: required base.Currency     currency
    12: optional string            shop_url
    13: optional string            party_email
    14: optional string            contact_email
    15: required base.ID           shop_id
    16: required base.ID           external_id
    17: optional ChargebackReason  chargeback_reason
    18: optional base.Content      content
    19: required bool              retrieval_request
}

struct ChargebackReason {
    1: optional base.ID                       code
    2: required chargeback.ChargebackCategory category
}

union ChargebackEvent {
    1: ChargebackCreateEvent           create_event
    2: ChargebackStatusChangeEvent     status_change_event
    3: ChargebackHoldStatusChangeEvent hold_status_change_event
    4: ChargebackReopenEvent           reopen_event
}

struct ChargebackCreateEvent {
    1: required ChargebackGeneralData           creation_data
    2: optional ChargebackStatusChangeEvent     status_change_event
    3: optional ChargebackHoldStatusChangeEvent hold_status_change_event
}

struct ChargebackStatusChangeEvent {
    1: required base.ID                       invoice_id
    2: required base.ID                       payment_id
    3: required base.ID                       chargeback_id
    4: required chargeback.ChargebackStatus   status
    5: optional chargeback.ChargebackStage    stage
    6: required base.Timestamp                created_at
    7: optional base.Timestamp                date_of_decision
}

struct ChargebackHoldStatusChangeEvent {
    1: required base.ID              invoice_id
    2: required base.ID              payment_id
    3: required base.ID              chargeback_id
    4: required base.Timestamp       created_at
    5: required ChargebackHoldStatus hold_status
}

struct ChargebackHoldStatus {
    1: optional bool will_hold_from_merchant
    2: optional bool was_hold_from_merchant
    3: optional bool hold_from_us
}

struct ChargebackReopenEvent {
    1: required base.ID                     invoice_id
    2: required base.ID                     payment_id
    3: required base.ID                     chargeback_id
    4: required base.Timestamp              created_at
    5: optional base.Amount                 levy_amount
    6: optional base.Amount                 body_amount
    7: optional chargeback.ChargebackStage  reopen_stage
}

struct ChargebackData {
    1: required ChargebackID           id
    2: required list<ChargebackEvent>  events
}

struct ChargebackFilter {
    1: required base.Timestamp                     date_from
    2: optional base.Timestamp                     date_to
    3: optional string                             provider_id
    4: optional list<chargeback.ChargebackStage>   stages
    5: optional list<chargeback.ChargebackStatus>  statuses
}

/** Service for work with chargebacks */
service Skipper {

    void processChargebackData(1: ChargebackEvent event)

    ChargebackData getChargebackData(1: base.ID invoice_id, 2: base.ID payment_id, 3: base.ID chargeback_id)

    ChargebackData getRetrievalRequestData(1: base.ID invoice_id, 2: base.ID payment_id, 3: base.ID chargeback_id)

    list<ChargebackData> getChargebacks(1: ChargebackFilter filter)

}

