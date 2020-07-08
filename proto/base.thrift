namespace java com.rbkmoney.damsel.skipper
namespace erlang skipper

typedef string ID

typedef string CardNumber

typedef i32 Number

typedef i32 Amount

typedef string Currency

typedef string Timestamp

struct Content {
    1: required string type
    2: required binary data
}