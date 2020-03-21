<!DOCTYPE html>
<html>
<body>

<?php
// phpinfo();
$con=mysqli_connect("DB","sshuser","Password@1","logindetails");

if (mysqli_connect_errno())
{
echo "Failed to connect to MySQL: " . mysqli_connect_error();
}

$result = mysqli_query($con,"SELECT * FROM ssh_logins");

echo "<table border='1'>
<tr>
<th>IP</th>
<th>Attempts</th>
</tr>";

while($row = mysqli_fetch_array($result))
{
echo "<tr>";
echo "<td>" . $row['IP'] . "</td>";
echo "<td>" . $row['Attempts'] . "</td>";
echo "</tr>";
}
echo "</table>";

mysqli_close($con);
?>

</body>
</html>