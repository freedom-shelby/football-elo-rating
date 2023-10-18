<?php
/**
 * Created by PhpStorm.
 * User: Shelby
 * Date: 11-Jun-18
 * Time: 5:18 PM
 */

$p1 = 1400;
$p2 = 1000;
$k = 30;

$a = 1 / (1 + 10 ** (($p1 - $p2) / 400));

$b = $a + $k * (1 - $a);

var_dump($b);

$p1 = 1000;
$p2 = 1400;
$k = 30;

$a = 1 / (1 + 10 ** (($p1 - $p2) / 400));

$b = $a + $k * (0 - $a);

var_dump($b);
