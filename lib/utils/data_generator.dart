import 'package:tensopay_wallet_prototype/models/bank.dart';
import 'package:tensopay_wallet_prototype/models/offer.dart';
import 'package:tensopay_wallet_prototype/models/shopping_offer.dart';

List<String?> MonthList = <String?>["Jan", "Feb", "Mar", "April", "May", "June", "July", "Aug", "Sep", "Oct", "Nov", "Dec"];
List<String?> YearList = <String?>["1991", "1992", "1993", "1994", "1995", "1996", "1997", "1998", "1999", "2020", "2021"];
List experiences = [
  Offer(review: 4, imgLocation: 'assets/images/australian_open.png', title: 'Australian Open', price: '\$150', description: 'Feel every emotion, hear every serve and escape the summer heat in this guest-only viewing suite, featuring private bathrooms and a food and drinks bar exclusive to Sportsnet® Super Suite guests. With a court-facing wall made entirely of glass and exclusive access to the suite’s private balcony, complete with two rows of padded, cinema-like seats along the court’s baseline, you will experience the Australian Open 2022 from one of the best seats in the house.', location: 'Melbourne, Australia'),
  Offer(review: 4, imgLocation: 'assets/images/sofitel_melb.png', title: 'Sofitel Melbourne', price: '\$250', description: 'Towering over Melbourne\'s glittering boutiques and chef hatted restaurants, Sofitel Melbourne on Collins graciously invites you to live the French way in five-star style. Taking the crown for the highest hotel views in the city, and ranked in the top 10% of hotels worldwide by Tripadvisor, this très chic retreat boasts stunning vistas at every turn from the award-winning No35 restaurant on the 35th floor, with its modern cuisine and outstanding wine collection, to the elegant suites and rooms.', location: 'Melbourne, Australia')
];
List places =[
  Offer(review: 4, imgLocation: 'assets/images/old_quebec.jpeg', title: 'Old Quebec', price: '\$ 250',
      description: 'Old Quebec is one of Canada\'s most popular historical areas and is well developed for tourism. In addition to the historical sites, other highlights include artists displaying their works on Rue du Trésor; interesting museums, like the Musée de la Civilisation; and unique shops and restaurants.',
      location: 'Old Quebec, Canada'),
  Offer(review: 4, imgLocation: 'assets/images/christ_redeemer.jpeg', title: 'Christ the Redeemer', price:  '\$ 40',
      description: 'Christ the Redeemer is an Art Deco statue of Jesus Christ in Rio de Janeiro, Brazil, created by French sculptor Paul Landowski and built by Brazilian engineer Heitor da Silva Costa, in collaboration with French engineer Albert Caquot.',
      location: 'Rio De Janeiro, Brasil'),
  Offer(review: 4, imgLocation: 'assets/images/cape_york.png', title: 'Cape York', price: '\$ 6900', description: 'Explore Cape York, one of Australia’s most fascinating corners, on an eight-day small-group tour (max. six travellers) with all meals included. Here lie some of Australia’s most ancient and awe-inspiring sights, from the iconic Telegraph Track through rugged terrain to the picturesque Torres Strait Islands. Follow 4WD tracks to a rainforest as old as time, golden beaches and rushing waterfalls, bound by the significance of Aboriginal Dreamtime stories.', location: 'Queensland, Australia'),
  Offer(review: 4, imgLocation: 'assets/images/natural_history_london.jpeg', title: 'Natural History Museum', price: 'Free',
      description: 'The Natural History Museum in London is a natural history museum that exhibits a vast range of specimens from various segments of natural history. It is one of three major museums on Exhibition Road in South Kensington, the others being the Science Museum and the Victoria and Albert Museum.',
      location: 'London, UK')
];
List shopping = [
  ShoppingOffer(title: 'Amazon', imgLocation: 'assets/images/amazon.png', price: '10%', description: 'Up to 10% cashback'),
  ShoppingOffer(title: 'Cotton-On', imgLocation: 'assets/images/cotton_on.png', price: '5%', description: '5% cashback'),
  ShoppingOffer(title: 'JB Hifi', imgLocation: 'assets/images/jb_hifi.png', price: '3%', description: '3% cashback'),
  ShoppingOffer(title: 'Kogan', imgLocation: 'assets/images/kogan.png', price: '2%', description: '2% cashback'),
  ShoppingOffer(title: 'Pizza Hut', imgLocation: 'assets/images/pizza_hut.png', price: '3.50%', description: 'Up to 3.50% cashback')
];
List<String?> banklist = <String?>[ "assets/images/nab.png", "assets/images/netwest.png", "assets/images/itau.png", "assets/images/cibc.png"];
// List account

