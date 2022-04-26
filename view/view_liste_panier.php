<?php
    require"livraisons.php";
?>
<table class="styled-table">
	<tr id="ligneTab">
		<td>ID Produit</td> <td>Nom</td><td>Quantité</td><td>Prix</td><td>Operation</td>
	</tr>

	<?php
		foreach ($lesProduitsPanier as $unProduit)
		{
			echo
			"
				<tr>
					<td> ".$unProduit['idproduit']."</td>
					<td> ".$unProduit['nom']."</td>
					<td> ".$unProduit['qte']."</td>
					<td> ".$unProduit['prix']."</td>
					<td> 
						
					</td>
				</tr>
			";
		}
        // echo "<br/> Total à payer : ".$lesProduitsPanier[0]['total']." euros.";
       
	?>
</table>

