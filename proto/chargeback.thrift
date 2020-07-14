namespace java com.rbkmoney.damsel.skipper
namespace erlang skipper

include "base.thrift"

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

struct ChargebackPending {}

struct ChargebackAccepted {
    1: optional base.Amount  levy_amount
    2: optional base.Amount  body_amount
}

struct ChargebackRejected {
    1: optional base.Amount  levy_amount
    2: optional base.Amount  body_amount
}

struct ChargebackCancelled {}