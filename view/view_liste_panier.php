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
						<a href='index.php?pn=panier&action=sup&idproduit=".$unProduit['idproduit']."'><img src='images/croix.png' heigth='30' width='30'></a>
						<a href='index.php?pn=panier&action=minus&idproduit=".$unProduit['idproduit']."'><img src='images/minus.png' heigth='30' width='30'></a>
						<a href='index.php?pn=panier&action=plus&idproduit=".$unProduit['idproduit']."'><img src='images/plus.png' heigth='30' width='30'></a>
					</td>
				</tr>
			";
		}
        // echo "<br/> Total à payer : ".$lesProduitsPanier[0]['total']." euros.";
       
	?>
</table>

