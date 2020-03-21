<!DOCTYPE html>
<html>
<body>

<?php
   $array = file('/home/sebinsebastian/Desktop/task/count.txt');
   foreach($array as $key => $line){
   	$array[$key] = explode(" ", $line);
   }
   echo "<table border="2">";
   foreach($array as $values)
   {
   	echo "<tr><td>";
   	echo "$values";
   	echo "</td></tr>";
   }
?>

</body>
</html>