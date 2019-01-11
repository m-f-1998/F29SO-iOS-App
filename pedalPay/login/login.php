
<?php

require_once $_SERVER['DOCUMENT_ROOT'].'/pedalPay/functions/dbOperation.php';

$response = array ();

if ($_SERVER['REQUEST_METHOD'] == 'POST') {

    if (isset($_POST['email']) && isset($_POST['password'])) {

        $db = new DbOperation();
        
        if ($db->userLogin($_POST['email'], $_POST['password'])) {
            
            $response['error'] = false;
            $response['message'] = $_POST['email'];
            
        } else {
            
            $response['error'] = true;
            $response['message'] = 'Invalid E-Mail or Password';
            
        }
        
    } else {
        
        $response['error'] = true;
        $response['message'] = 'All Fields are Required to Log In';
    
    }

} else {
    
    $response['error'] = true;
    $response['message'] = "Request Not Allowed";
    
}

echo json_encode($response);

?>
