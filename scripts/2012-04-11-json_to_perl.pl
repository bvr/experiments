
use JSON::XS;
use Data::Dump;

dd decode_json do { local $/; <DATA> };

__DATA__
    {
        "id":"0",
        "label": "0x5000",
        "destinationModule": "ACE C2",
        "sizeTotal": "57",
        "sizePayload": "54",
        "transmitRate": "80",
        "transmitPosition": "B",
        "airLevelUse": "bus label"
    }
