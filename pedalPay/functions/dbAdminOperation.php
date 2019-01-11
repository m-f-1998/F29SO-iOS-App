<?php

class dbOperation {

    private $conn;

    function __construct () {

        require_once $_SERVER['DOCUMENT_ROOT'].'/pedalPay/dbConnection/constants.php';
        require_once $_SERVER['DOCUMENT_ROOT'].'/pedalPay/dbConnection/dbConnect.php';

        $db = new DbConnect ();
        $this->conn = $db->connect ();

    }

    public function userDetails () {

        $stmt = $this->conn->query("SELECT id, email FROM users;");
        $res = array();
        while ($data = $stmt->fetch_assoc()) {
            
            array_push($res, $data);
            
        }
        return $res;

    }

    public function userBookings ($pid) {

        $stmt = $this->conn->prepare("SELECT * FROM booking WHERE pid = ?;");
 	$stmt->bind_param ("s", $pid);
        $stmt->execute ();

        $res = array();
        while ($data = $stmt->fecth_assoc()) {
            
            array_push($res, $data);
            
        }
        return $res;

    }

    public function bikeUpdates ($bid) {

        $stmt = $this->conn->prepare("SELECT * FROM bikeupdates WHERE bookid = ?;");
        $stmt->bind_param ("s", $bid);
        $stmt->execute ();

        $res = array();
        while ($data = $stmt->fecth_assoc()) {
            
            array_push($res, $data);
            
        }
        return $res;

    }

?>
