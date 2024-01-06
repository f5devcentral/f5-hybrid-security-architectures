resource "kubernetes_config_map" "mongo_initdb" {
  metadata {
    name = "mongo-initdb"
  }

  data = {
    "mongo-init.js" = <<-EOF
      print('Start #################################################################');

      var products = [{
          "id": "123",
          "name": "Elysian Space Dust IPA",
          "price": "10.49",
          "description": "Washington- American Double/Imperial IPA- 8.2% ABV. 73 IBUs. Pours a clear golden amber color with a thick white head. Aromas of pine and citrus with a bit of breadiness and tropical fruit. Flavors of tropical fruit, citrus and pine with notes of orange peel. Enjoy!",
          "imageUrl": "/images/elysian.png",
          "averageRating": "4.5"
      }, {
          "id": "234",
          "name": "New Belgium Voodoo Ranger Imperial IPA",
          "price": "8.99",
          "description": "Colorado & NC- American Double/Imperial IPA- 9% ABV. 85 IBUs. A bold imperial IPA with a rare blend of Mosaic, Calypso, Bravo, and Delta hops creating an explosion of fresh cut pine and citrus flavors.",
          "imageUrl": "/images/voodoo.png",
          "averageRating": "4.6"
      }, {
          "id": "345",
          "name": "Dogfish Head 90-Minute IPA",
          "price": "12.99",
          "description": "Delaware- American Double / Imperial IPA- 9% ABV. Extremely complex; there is plenty of malt in this brew to match up with the extreme hopping program, leaving citrus, raisin and brandied fruitcake aromas and flavors. A hophead joy!",
          "imageUrl": "/images/dogfish.png",
          "averageRating": "4.7"
      }, {
          "id": "456",
          "name": "Founders KBS (Kentucky Breakfast Stout)",
          "price": "17.99",
          "description": "Michigan- American Double/Imperial Stout- 11.2% ABV. BARREL AGED. An imperial stout brewed with a massive amount of coffee and chocolates, then cave-aged in oak bourbon barrels for an entire year to make sure wonderful bourbon undertones come through in the finish. Awesome!",
          "imageUrl": "/images/founders.png",
          "averageRating": "4.6"
      }, {
          "id": "567",
          "name": "Weihenstephaner Hefe Weissbier",
          "price": "10.99",
          "description": "Germany- Hefeweizen- Nothing refreshes you more than this quintessential wheat beer with its wonderful yeasty fragrance and taste. It goes well with dishes that do not have too intensive a flavor, especially the Bavarian specialty Weisswurst. BeerAdvocate's #18 Top Beer on Planet Earth",
          "imageUrl": "/images/weihenstephaner.png",
          "averageRating": "4.9"
      }, {
          "id": "678",
          "name": "St Bernardus Abt 12",
          "price": "23.49",
          "description": "Belgium- Quadrupel- 10.5% ABV. Here's a traditional Abbey Ale brewed in the classic style of Belgium's Trappist Monks. It is almost ebony in color, smooth, creamy and full-bodied, with big richness of texture that is oily and assertive.",
          "imageUrl": "/images/stbernardus.png",
          "averageRating": "4.5"
      }, {
          "id": "789",
          "name": "Chimay Grande Reserve Blue",
          "price": "24.99",
          "description": "Belgium- Belgian Strong Dark Ale- 9% ABV. TRAPPIST ALE. The color of this beer is dark and inviting. A rich and lively sweetness gives way to a drier finish. A peppery spiciness is balanced by thyme, cedar & a touch of nutmeg. BeerAdvocate's #25 of 25 All-Time Top Beers 2008.",
          "imageUrl": "/images/chimay.png",
          "averageRating": "4.9"
      }, {
          "id": "890",
          "name": "Unibroue - La Fin Du Monde",
          "price": "11.99",
          "description": "Canada- Tripel- 9% ABV. La Fin du Monde has a brilliant golden color with vigorously effervescent foam. It is mildly yeasty with a pleasingly complex palate of malt, fruit and spice notes followed by a smooth, dry finish. BeerAdvocate's #13 of 25 All-Time Top Beers 2008.",
          "imageUrl": "/images/unibroue.png",
          "averageRating": "4.6"
      }, {
          "id": "901",
          "name": "Ballast Point Sculpin IPA",
          "price": "13.99",
          "description": "California- American India Pale Ale (IPA)- 7% ABV. World Beer Cup Gold medal 2014. Aromas of apricot, peach, mango and lemon. Its lighter body also brings out the crispness of the hops. Though not categorized as an Imperial IPA, this beer has a very strong hop character.",
          "imageUrl": "/images/ballast.png",
          "averageRating": "4.8"
      },
      {
          "id": "112",
          "name": "Samuel Adams Utopias",
          "price": "239.99",
          "description": "Massachusetts- American Strong Ale- 28% ABV. BARREL AGED. 2019 vintage is a blend of batches, some aged up to 26 years in a variety of barrels. The '19 recipe includes Utopias aged in Aquavit, Carcavelos and Ruby Port barrels as well as Cognac and Madeira finishing barrels.",
          "imageUrl": "/images/samueladams.png",
          "averageRating": "4.6"
      },
      {
          "id": "223",
          "name": "Kentucky Bourbon Barrel Ale",
          "price": "11.99",
          "description": "Kentucky- American Strong Ale- 8+%ABV. A unique sipping beer with the distinctive nose of a well-crafted bourbon. Aged for up to 6 weeks in freshly decanted bourbon barrels from some of Kentucky's finest distilleries. Subtle flavors of vanilla and oak. Pleasantly smooth and robust.",
          "imageUrl": "/images/kentucky.png",
          "averageRating": "4.3"
      }, {
          "id": "334",
          "name": "Ayinger Celebrator Doppelbock",
          "price": "11.99",
          "description": "Germany- Doppelbock- 6.7% ABV. Ayinger Celebrator is dark amber, nearly black in color. There is a distinct maltiness in this beer, with pronounced coffee notes. There is very little of the sweetness that is frequently tasted with Doppelbocks, resulting in a well balanced brew.",
          "imageUrl": "/images/ayinger.png",
          "averageRating": "4.3"
      }
      ]

      var users = [{
          "id": "12345",
          "cartItems": ["123", "234", "456"]
      }]

      db = db.getSiblingDB('vue-db');

      db.createCollection('products');
      db.products.insert(products);

      db.createCollection('users');
      db.users.insert(users);

      print('END #################################################################');
    EOF
  }
}
