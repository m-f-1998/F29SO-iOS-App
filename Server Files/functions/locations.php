<?php

require_once $_SERVER['DOCUMENT_ROOT'].'/login/dbOperation.php';

$response = array ();

if ($_SERVER['REQUEST_METHOD'] == 'POST') {

    $db = new DbOperation();
    $response['error'] = false;
    $response['message'] = $db->getLocations();

} else {
    
    $response['error'] = true;
    $response['message'] = "Request Not Allowed";
    
}

echo json_encode($response);

?>
