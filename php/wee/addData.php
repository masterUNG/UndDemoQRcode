<?php
header("content-type:text/javascript;charset=utf-8");
error_reporting(0);
error_reporting(E_ERROR | E_PARSE);
$link = mysqli_connect('localhost', 'student1', 'Abc12345', "wee");

if (!$link) {
    echo "Error: Unable to connect to MySQL." . PHP_EOL;
    echo "Debugging errno: " . mysqli_connect_errno() . PHP_EOL;
    echo "Debugging error: " . mysqli_connect_error() . PHP_EOL;
    
    exit;
}

if (!$link->set_charset("utf8")) {
    printf("Error loading character set utf8: %s\n", $link->error);
    exit();
	}

if (isset($_GET)) {
	if ($_GET['isAdd'] == 'true') {
				
		$NameImage = $_GET['NameImage'];
		$PathImage = $_GET['PathImage'];
		$Detail = $_GET['Detail'];
		$Lat = $_GET['Lat'];
		$Lng = $_GET['Lng'];
		
							
		$sql = "INSERT INTO `imageTABLE`(`id`, `NameImage`, `PathImage`, `Detail`, `Lat`, `Lng`) VALUES (Null,'$NameImage','$PathImage','$Detail','$Lat','$Lng')";

		$result = mysqli_query($link, $sql);

		if ($result) {
			echo "true";
		} else {
			echo "false";
		}

	} else echo "Welcome Master UNG";
   
}
	mysqli_close($link);
?>