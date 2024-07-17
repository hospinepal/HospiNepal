<?php

//$xkey = "234454719e6f4fac86360acbf9559a87";
//$xx = "fonepay123,P,d1580724437729,30,NPR,06/27/2017,Hello,test,https://devadminapi.fonepay.com/ConvergentMerchantDummyweb/MerchantVerification";


$filters = array_fill(0, 2, null);
for($i = 1; $i < $argc; $i++) {
    $filters[$i - 1] = $argv[$i];
}
$xkey = $filters[0];
$xx = $filters[1];

//execute
$yy = hash_hmac('sha512', $xx, $xkey);
echo $yy;

?>

