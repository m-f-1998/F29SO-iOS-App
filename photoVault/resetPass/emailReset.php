<?php
    
    require_once $_SERVER['DOCUMENT_ROOT'].'/photoVault/functions/dbOperation.php' ;
    $response = array () ;
    
    if ($_SERVER['REQUEST_METHOD'] == 'POST') {
        
        if (isset ($_POST['email'])) {
            
            $db = new DbOperation () ;
            
            if ($db->resetPass ($_POST['email'])) {
                
                $response['error'] = false ;
                $response['message'] = 'Password Reset Link Sent To E-Mail If User Exists' ;
                
            }
            
        } else {
            
            $response['error'] = true;
            $response['message'] = 'E-Mail is Not Set' ;
            
        }
        
    } else {
        
        $response['error'] = true;
        $response['message'] = 'Request Not Allowed' ;
        
    }
    
    echo json_encode ($response) ;
    
?>
