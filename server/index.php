<?php
include("bdd.php");
include("dao.php");

$request_method = $_SERVER["REQUEST_METHOD"];
if(empty($_GET["resource"])){
    header("HTTP/1.0 404 no ressource selected");
    echo "404 no ressource selected";
    exit();
}

$resource = $_GET["resource"];
$dao = new DAO($conn, $resource);

switch($request_method)
{
    case 'GET':
        // Récupère ressources
        if(!empty($_GET["id"]))
        {
            $id=intval($_GET["id"]);
            $dao->get($id);
        }
        else
        {
            $dao->get();
        }
        break;
    case 'POST':
        // Ajouter une ressources
        $dao->connection();
        break;
        
    case 'PUT':
        // Modifier
        $id = intval($_GET["id"]);
        $dao->update($id);
        break;    
    case 'DELETE':
        // Supprimer
        $id = intval($_GET["id"]);
        $dao->delete($id);
        break;
    default:
        // Invalid Request Method
        header("HTTP/1.0 405 Method Not Allowed");
        break;

}
?>