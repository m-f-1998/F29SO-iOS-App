<?php

require_once $_SERVER['DOCUMENT_ROOT'].'/pedalPay/functions/dbOperation.php';
 
$response = array();
 
if ($_SERVER['REQUEST_METHOD'] == 'POST') {
    
    if (!verifyRequiredParams(array('email', 'password'))) {
        
        $email = $_POST['email'];
        $password = $_POST['password'];
        
        $db = new DbOperation();
 
        $result = $db->createUser($email, $password);
 
        if ($result == USER_CREATED) {
            
            $response['error'] = false;
            $response['message'] = 'Account Created Successfully';
            
        } elseif ($result == USER_ALREADY_EXIST) {
            
            $response['error'] = true;
            $response['message'] = 'Account Already Exists';
            
        } elseif ($result == USER_NOT_CREATED) {
            
            $response['error'] = true;
            $response['message'] = 'Some Error Occurred';
            
        }
        
    } else {
        
        $response['error'] = true;
        $response['message'] = 'All Fields are Required to Register';
        
    }
    
} else {
    
    $response['error'] = true;
    $response['message'] = 'Invalid Request';
    
}
 
function verifyRequiredParams($required_fields) {
 
    $request_params = $_REQUEST;
 
    foreach ($required_fields as $field) {
        
        if (!isset($request_params[$field]) || strlen(trim($request_params[$field])) <= 0) { 
            
            return true;
            
        }
        
    }
    
    return false;
    
}
 
echo json_encode($response);

?>
