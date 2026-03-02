import 'package:flutter/material.dart';
import 'custom_widgets.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/gestures.dart';

class AllergyInfoPage extends StatefulWidget {
  const AllergyInfoPage({super.key});

  @override
  _AllergyInfoPageState createState() => _AllergyInfoPageState();
}

class _AllergyInfoPageState extends State<AllergyInfoPage> {
  int _selectedIndex = 2;

  void _onItemTapped(int index) {
    if (index == 2) return;
    Navigator.pop(context);
  }

  Future<void> _launchURL() async {
    final Uri url = Uri.parse('https://foodallergycanada.ca/');
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFECFFF8),
      appBar: CustomAppBar(),
      drawer: buildSideBarMenu(context),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: const Text(
                "What’s in Your Food?",
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
            const SizedBox(height: 5),
            const Center(
              child: Text(
                "Know Your Allergens!",
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
            ),
            const SizedBox(height: 10),
            Align(
              alignment: Alignment.centerLeft,
              child: Container(
                width: 120,
                height: 3,
                color: const Color(0xFF6EA08D),
              ),
            ),
            const SizedBox(height: 40),
            Expanded(
              child: Column(
                children: [
                  Expanded(
                    child: GridView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 15,
                        crossAxisSpacing: 15,
                        childAspectRatio: 1.9,
                      ),
                      itemCount: 8,
                      itemBuilder: (context, index) {
                        List<Map<String, String>> allergens = [
                          {"name": "Milk", "image": "assets/images/milk.png"},
                          {"name": "Egg", "image": "assets/images/egg.png"},
                          {"name": "Wheat", "image": "assets/images/wheat.png"},
                          {"name": "Soy", "image": "assets/images/soy.png"},
                          {
                            "name": "Tree Nuts",
                            "image": "assets/images/treenut.png"
                          },
                          {
                            "name": "Peanut",
                            "image": "assets/images/peanut.png"
                          },
                          {"name": "Fish", "image": "assets/images/fish.png"},
                          {
                            "name": "Shellfish",
                            "image": "assets/images/shellfish.png"
                          },
                        ];

                        return allergenCard(
                          allergens[index]["name"]!,
                          allergens[index]["image"]!,
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 5),

// Reference Link (centered and styled)
                  Center(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.info_outline,
                            size: 16, color: Colors.black),
                        const SizedBox(width: 5),
                        RichText(
                          text: TextSpan(
                            text: 'Information source: ',
                            style: const TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 13,
                              color: Colors.black,
                            ),
                            children: <TextSpan>[
                              TextSpan(
                                text: 'Food Allergy Canada',
                                style: const TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 13,
                                  color: Colors.blue,
                                  decoration: TextDecoration.underline,
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = _launchURL,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(
                      height: 15), // keep some spacing before the grid
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }

  Widget allergenCard(String name, String imagePath) {
    return GestureDetector(
      onTap: () {
        if (name == "Egg") {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => EggAllergyDetailPage(),
            ),
          );
        }
        if (name == "Milk") {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MilkAllergyDetailPage(),
            ),
          );
        }
        if (name == "Wheat") {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => WheatAllergyDetailPage(),
            ),
          );
        }
        if (name == "Soy") {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SoyAllergyDetailPage(),
            ),
          );
        }
        if (name == "Tree Nuts") {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TreeNutAllergyDetailPage(),
            ),
          );
        }
        if (name == "Peanut") {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PeanutAllergyDetailPage(),
            ),
          );
        }
        if (name == "Fish") {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => FishAllergyDetailPage(),
            ),
          );
        }
        if (name == "Shellfish") {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ShellfishAllergyDetailPage(),
            ),
          );
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(imagePath, width: 50, height: 50),
            const SizedBox(width: 10),
            Text(
              name,
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// EGG ALLERGY DETAIL PAGE

class EggAllergyDetailPage extends StatelessWidget {
  const EggAllergyDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFECFFF8),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.chevron_left, color: Colors.black, size: 30),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: const Text(
          'Egg',
          style: TextStyle(
            fontFamily: 'Poppins',
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            Container(
              width: 120,
              height: 3,
              color: const Color(0xFF6EA08D),
            ),
            const SizedBox(height: 16),
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.asset(
                'assets/images/eggy.png',
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 20),
            collapsibleSection(
              title: "Quick facts",
              content:
                  "• Eggs have two allergenic parts, the yolk and the white.\n"
                  "• Eggs are considered a priority food allergen by Health Canada.\n"
                  "• Many children with an egg allergy may outgrow the allergy within a few years. For others, an egg allergy can be a lifelong condition. If your child has an egg allergy, consult your allergist before reintroducing your child to egg products.\n"
                  "• The proteins in eggs from chickens are similar to those found in eggs from ducks, geese, quails and other birds or fowl. Therefore, people who are allergic to eggs from chickens may also experience reactions to the eggs from other animals.\n"
                  "• Some people with egg allergy can consume extensively heated/baked products that contain egg (i.e., with the product completely cooked throughout). If you have an egg allergy, please consult with your allergist before consuming any baked products containing egg.",
            ),
            collapsibleSection(
              title: "Allergic reactions to eggs",
              content:
                  "• If you have an egg allergy, keep an epinephrine auto-injector (e.g., EpiPen®, ALLERJECT®) with you at all times. Epinephrine is the first-line treatment for severe allergic reactions (anaphylaxis).",
            ),
            collapsibleSection(
              title: "Be allergy-aware: How to avoid eggs",
              content:
                  "• Read ingredient labels every time you buy or eat a product. If the label indicates that a product \"Contains\" or \"may contain\" egg, do not eat it. If you do not recognize an ingredient, if there is no ingredient list available, or if you don't understand the language written on the packaging, avoid the product.\n"
                  "• Do the Triple Check and read the label:\n"
                  "• Once at the store before buying it.\n"
                  "• Once when you get home and put it away.\n"
                  "• Again before you serve or eat the product.\n"
                  "• Always carry your epinephrine auto-injector. It's recommend that if you do not have your auto-injector with you, that you do not eat.\n"
                  "• Check with manufacturers directly if you are not sure if a product is safe for you.\n"
                  "• Be careful when buying products from abroad, since labelling rules differ from country to country.\n"
                  "• Watch for cross-contamination, which is when a small amount of a food allergen (e.g., egg) gets into another food accidentally, or when it's present in saliva, on a surface, or on an object. This small amount of an allergen could cause an allergic reaction.",
            ),
            collapsibleSection(
              title: "Other names for eggs",
              content: "• Albumin/Albumen\n"
                  "• Conalbumin\n"
                  "• Egg substitutes such as Egg BeatersTM\n"
                  "• Eggnog\n"
                  "• Globulin\n"
                  "• Livetin\n"
                  "• Lysozyme\n"
                  "• Meringue\n"
                  "• Ovalbumin\n"
                  "• Ovoglobulin\n"
                  "• Ovolactohydrolyze proteins\n"
                  "• Ovomacroglobulin\n"
                  "• Ovomucin, ovomucoid\n"
                  "• Ovotransferrin\n"
                  "• Ovovitellin\n"
                  "• Silico-albuminate\n"
                  "• Simplesse® (fat replacer)\n"
                  "• Vitellin",
            ),
            collapsibleSection(
              title: "Possible sources of eggs",
              content: "• Alcoholic cocktails/drinks\n"
                  "• Baby food\n"
                  "• Baked goods and baking mixes\n"
                  "• Battered/fried foods\n"
                  "• Candy, chocolate\n"
                  "• Cream-filled pies\n"
                  "• Creamy dressings, salad dressings, spreads\n"
                  "• Desserts\n"
                  "• Egg/fat substitutes\n"
                  "• Fish mixtures\n"
                  "• Foam milk topping on coffee\n"
                  "• Homemade root beer, malt drink mixes\n"
                  "• Icing, glazes such as egg washes\n"
                  "• Lecithin\n"
                  "• Meat mixtures (e.g. hamburgers, hot dogs, meatballs, meatloaf)\n"
                  "• Pasta\n"
                  "• Quiche, soufflé\n"
                  "• Sauces such as Béarnaise, Hollandaise, Newburg\n"
                  "• Soups, broths, bouillons",
            ),
            collapsibleSection(
              title: "Non-food sources of eggs",
              content: "• Anaesthetic such as Diprivan®\n"
                  "• Certain vaccines\n"
                  "• Craft materials, including some paints\n"
                  "• Hair care products\n"
                  "• Medications",
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget collapsibleSection({required String title, required String content}) {
    return Theme(
      data: ThemeData().copyWith(
        dividerColor: Colors.transparent,
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
      ),
      child: ExpansionTile(
        tilePadding: const EdgeInsets.symmetric(vertical: 5),
        title: Text(
          title,
          style: const TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w700,
            fontSize: 20,
            color: Colors.black,
          ),
        ),
        childrenPadding: const EdgeInsets.only(bottom: 10),
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 10, right: 10),
            child: Text(
              content,
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontSize: 16,
                color: Colors.black87,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class MilkAllergyDetailPage extends StatelessWidget {
  const MilkAllergyDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFECFFF8),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.chevron_left, color: Colors.black, size: 30),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Milk',
          style: TextStyle(
            fontFamily: 'Poppins',
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            Container(
              width: 120,
              height: 3,
              color: const Color(0xFF6EA08D),
            ),
            const SizedBox(height: 16),
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.asset(
                'assets/images/milky.jpg',
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 20),
            collapsibleSection(
              title: "Quick facts",
              content:
                  "• Milk is considered a priority food allergen by Health Canada. Priority food allergens are the foods that cause the majority of allergic reactions.\n"
                  "• Milk allergy is caused by a reaction to the protein in cow's milk.\n"
                  "• The protein in cow's milk is very similar to those found in milk from goats, sheep, and other mammals like deer and buffalo. Individuals allergic to cow's milk will likely experience reactions to other types of milk.\n"
                  "• Some people with milk allergy can consume extensively heated/baked products that contain milk (with the product completely cooked throughout). If you or your child has a milk allergy, please speak to your allergist before consuming any baked products containing milk.\n"
                  "• Many children with a milk allergy may outgrow the allergy within a few years. For others, a milk allergy can be a lifelong condition. If your child has an milk allergy, consult your allergist before reintroducing your child to milk products.\n"
                  "• A milk allergy is different than a milk (or lactose) intolerance. Unlike people with lactose intolerance, individuals with milk allergy have an immune system that reacts abnormally to milk proteins and it can be life-threatening.\n"
                  "• Lactose intolerance occurs when a person cannot digest lactose, a component of milk, because their body does not produce enough of a specific enzyme that breaks down lactose. Symptoms of lactose intolerance include abdominal pain, bloating, and diarrhea after milk ingestion. Lactose intolerance is not an allergy and is not life-threatening.\n"
                  "• If you are unsure whether you have a milk allergy or lactose intolerance, please talk to your doctor.\n"
                  "• If you are managing lactose intolerance, visit this Dietitians of Canada web page.",
            ),
            collapsibleSection(
              title: "Allergic reactions to milk",
              content:
                  "• If you have an allergy to milk, keep an epinephrine auto-injector (e.g., EpiPen®, ALLERJECT®) with you at all times. Epinephrine is the first-line treatment for severe allergic reactions (anaphylaxis).",
            ),
            collapsibleSection(
              title: "Be allergy-aware: How to avoid milk",
              content:
                  "• Read ingredient labels every time you buy or eat a product. If the label indicates that a product “Contains” or “may contain” milk, do not eat it. If you do not recognize an ingredient, if there is no ingredient list available, or if you don’t understand the language written on the packaging, avoid the product.\n\n"
                  "• Do The Triple Check and read the label:\n"
                  "   • Once at the store before buying it.\n"
                  "   • Once when you get home and put it away.\n"
                  "   • Again before you serve or eat the product.\n\n"
                  "• Always carry your epinephrine auto-injector. It’s recommend that if you do not have your auto-injector with you, that you do not eat.\n"
                  "• Check with manufacturers directly if you are not sure if a product is safe for you.\n"
                  "• Be careful when buying products from abroad, since labelling rules differ from country to country.\n"
                  "• Watch for cross-contamination, which is when a small amount of a food allergen (e.g., milk) gets into another food accidentally, or when it’s present in saliva, on a surface, or on an object. This small amount of an allergen could cause an allergic reaction.",
            ),
            collapsibleSection(
              title: "Other names for milk",
              content:
                  "• Ammonium/calcium/magnesium/potassium/sodium caseinate\n"
                  "• Beta-lactoglobulin\n"
                  "• Casein/caseinate/rennet casein\n"
                  "• Curds\n"
                  "• Delactosed/demineralised whey\n"
                  "• Dry milk/milk/sour cream/sour milk solids\n"
                  "• Hydrolyzed casein, hydrolyzed milk protein\n"
                  "• Lactalbumin/lactalbumin phosphate\n"
                  "• Lactoferrin\n"
                  "• Lactoglobulin\n"
                  "• Milk derivative/fat/protein\n"
                  "• Modified milk ingredients\n"
                  "• OptaTM, Simplesse®  (fat replacers)\n"
                  "• Whey, whey protein concentrate",
            ),
            collapsibleSection(
              title: "Possible sources of milk",
              content:
                  "• Artificial butter, butter fat/flavour/oil, ghee, margarine\n"
                  "• Baked goods and baking mixes\n"
                  "• Buttermilk, cream, dips, salad dressings, sour cream, spreads\n"
                  "• Canned tuna, e.g. seasoned or mixed with other ingredients\n"
                  "• Caramel colouring/flavouring\n"
                  "• Casein in wax used on fresh fruits and vegetables\n"
                  "• Casseroles, frozen prepared foods\n"
                  "• Cereals, cookies, crackers\n"
                  "• Cheese, cheese curds\n"
                  "• Chocolate\n"
                  "• Desserts\n"
                  "• Egg/fat substitutes\n"
                  "• Flavoured coffee, coffee whitener, non-dairy creamer\n"
                  "• Glazes, nougat\n"
                  "• Gravy, sauces\n"
                  "• High protein flour\n"
                  "• Infant baby cereals/infant formula, follow-up formula, nutrition supplements for toddlers and children\n"
                  "• Kefir (milk drink), kumiss (fermented milk drink), malt drink mixes\n"
                  "• Meats such as deli meats, hot dogs, patés, sausages\n"
                  "• Pizza\n"
                  "• Instant/mashed/scalloped potatoes\n"
                  "• Seasonings\n"
                  "• Snack foods\n"
                  "• Soups, soup mixes\n"
                  "• Soy cheese",
            ),
            collapsibleSection(
              title: "Non-food sources of milk",
              content: "• Cosmetics\n"
                  "• Medications and health supplements\n"
                  "• Pet food",
            ),
            collapsibleSection(
              title: "Ingredients that do not contain milk protein",
              content: "• Calcium/sodium lactate\n"
                  "• Calcium/sodium stearoyl lactylate\n"
                  "• Cocoa butter\n"
                  "• Cream of tartar\n"
                  "• Oleoresin\n\n"
                  "Note: The above lists are not complete and may change.",
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget collapsibleSection({required String title, required String content}) {
    return Theme(
      data: ThemeData().copyWith(
        dividerColor: Colors.transparent,
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
      ),
      child: ExpansionTile(
        tilePadding: const EdgeInsets.symmetric(vertical: 5),
        title: Text(
          title,
          style: const TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w700,
            fontSize: 20,
            color: Colors.black,
          ),
        ),
        childrenPadding: const EdgeInsets.only(bottom: 10),
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Text(
              content,
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontSize: 16,
                color: Colors.black87,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// WHEAT ALLERGY DETAIL PAGE

class WheatAllergyDetailPage extends StatelessWidget {
  const WheatAllergyDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFECFFF8),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.chevron_left, color: Colors.black, size: 30),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: const Text(
          'Wheat',
          style: TextStyle(
            fontFamily: 'Poppins',
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            Container(
              width: 120,
              height: 3,
              color: const Color(0xFF6EA08D),
            ),
            const SizedBox(height: 16),
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.asset(
                'assets/images/wheaty.png',
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 20),
            collapsibleSection(
              title: "Quick facts",
              content:
                  "• Wheat and triticale are considered priority food allergens by Health Canada. Priority food allergens are the foods that cause the majority of allergic reactions.\n"
                  "• Triticale is a hybrid grain created by crossing wheat and rye. Although not typically available commercially, people with wheat allergy should avoid triticale as well.\n"
                  "• A wheat allergy develops most commonly in infants and tends to be outgrown. Adults who develop a wheat allergy are likely to retain it. If your child has a wheat allergy, consult your allergist before reintroducing your child to wheat products.\n"
                  "• Wheat allergy and celiac disease are two different conditions.\n"
                  "• A wheat allergy occurs when a person's immune system reacts abnormally to wheat proteins; it can be life-threatening.\n"
                  "• When a person with celiac disease eats food containing the protein gluten (found in wheat and some other grains), it results in immune-mediated damage to the lining of the small intestine, which stops the body from absorbing nutrients. This can lead to anemia, chronic diarrhea, weight loss, fatigue, abdominal cramping, bloating and eventually malnutrition.\n"
                  "• If you are unsure whether you have a wheat allergy or celiac disease, consult with your doctor.",
            ),
            collapsibleSection(
              title: "Allergic reactions to wheat and triticale",
              content:
                  "• Exercise-induced anaphylaxis is most commonly linked to wheat, although other foods have also been known to trigger this condition. Individuals with exercise-induced anaphylaxis can experience anaphylactic reactions when they exercise soon after eating a particular food allergen. They do not react, however, if they delay exercise by several hours.\n\n"
                  "• If you have an allergy to wheat and/or triticale, keep an epinephrine auto-injector (e.g., EpiPen®, ALLERJECT®) with you at all times. Epinephrine is the first-line treatment for severe allergic reactions (anaphylaxis).",
            ),
            collapsibleSection(
              title: "Be allergy-aware: How to avoid wheat and triticale",
              content:
                  "• Read ingredient labels every time you buy or eat a product. If the label indicates that a product “Contains” or “may contain” wheat, do not eat it. If you do not recognize an ingredient, if there is no ingredient list available, or if you don’t understand the language written on the packaging, avoid the product.\n\n"
                  "• Do the Triple Check and read the label:\n"
                  "   • Once at the store before buying it.\n"
                  "   • Once when you get home and put it away.\n"
                  "   • Again before you serve or eat the product.\n\n"
                  "• Always carry your epinephrine auto-injector. It’s recommend that if you do not have your auto-injector with you, that you do not eat.\n"
                  "• Check with manufacturers directly if you are not sure if a product is safe for you.\n"
                  "• Be careful when buying products from abroad, such as packaged foods and health supplements, since labelling rules differ from country to country.\n"
                  "• Watch for cross-contamination, which is when a small amount of a food allergen (e.g., wheat) gets into another food accidentally, or when it’s present in saliva, on a surface, or on an object. This small amount of an allergen could cause an allergic reaction.\n"
                  "• Some “gluten-free” products may be cross-contaminated if made in a shared kitchen with wheat products. Check with bakeries and manufacturers directly.",
            ),
            collapsibleSection(
              title: "Other names for wheat",
              content: "• Atta\n"
                  "• Bulgur\n"
                  "• Couscous\n"
                  "• Durum\n"
                  "• Einkorn\n"
                  "• Emmer\n"
                  "• Enriched flour, white flour, whole-wheat flour\n"
                  "• Farina\n"
                  "• Graham flour, high gluten flour, high protein flour\n"
                  "• Kamut\n"
                  "• Seitan\n"
                  "• Semolina\n"
                  "• Spelt (dinkel, farro)\n"
                  "• Triticale (a cross between wheat and rye)\n"
                  "• Titicum aestivom\n"
                  "• Wheat bran, wheat flour, wheat germ, wheat gluten, wheat starch",
            ),
            collapsibleSection(
              title: "Possible sources of wheat",
              content:
                  "• Baked goods, e.g. breads, bread crumbs, cakes, cereals, cookies, crackers, donuts, muffins, pasta, baking mixes\n"
                  "• Baking powder\n"
                  "• Batter-fried foods\n"
                  "• Binders and fillers in processed meat, poultry and fish products\n"
                  "• Beer\n"
                  "• Coffee substitutes\n"
                  "• Chicken and beef broth\n"
                  "• Deli meats, hot dogs, and surimi\n"
                  "• Falafel\n"
                  "• Gelatinized starch, modified starch, modified food starch\n"
                  "• Gravy mixes, bouillon cubes\n"
                  "• Communion/altar bread and wafers\n"
                  "• Hydrolyzed plant protein\n"
                  "• Ice cream\n"
                  "• Imitation bacon\n"
                  "• Pie fillings, puddings, snack foods\n"
                  "• Prepared ketchup and mustard\n"
                  "• Salad dressings\n"
                  "• Sauces, like chutney and tamari\n"
                  "• Seasonings, natural flavouring (from malt, wheat)\n"
                  "• Soy sauce\n"
                  "• Candy, chocolate bars\n"
                  "• Pie fillings and puddings",
            ),
            collapsibleSection(
              title: "Non-food sources of wheat",
              content:
                  "• Modeling compound/clay such as Play-Doh® and some glues\n"
                  "• Cosmetics, hair care products\n"
                  "• Medications, vitamins, herbal supplements\n"
                  "• Pet food, including fish food, and pet bedding\n"
                  "• Wreath decorations",
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget collapsibleSection({required String title, required String content}) {
    return Theme(
      data: ThemeData().copyWith(
        dividerColor: Colors.transparent,
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
      ),
      child: ExpansionTile(
        tilePadding: const EdgeInsets.symmetric(vertical: 5),
        title: Text(
          title,
          style: const TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w700,
            fontSize: 20,
            color: Colors.black,
          ),
        ),
        childrenPadding: const EdgeInsets.only(bottom: 10),
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 10, right: 10),
            child: Text(
              content,
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontSize: 16,
                color: Colors.black87,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// SOY ALLERGY DETAIL PAGE

class SoyAllergyDetailPage extends StatelessWidget {
  const SoyAllergyDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFECFFF8),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.chevron_left, color: Colors.black, size: 30),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: const Text(
          'Soy',
          style: TextStyle(
            fontFamily: 'Poppins',
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            Container(
              width: 120,
              height: 3,
              color: const Color(0xFF6EA08D),
            ),
            const SizedBox(height: 16),
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.asset(
                'assets/images/soyy.png',
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 20),
            collapsibleSection(
              title: "Quick facts",
              content:
                  "• Soy is considered a priority food allergen by Health Canada. Priority food allergens are the foods that cause the majority of allergic reactions.\n"
                  "• Soy comes from soybeans, a type of legume. Soybeans can be made into flour, soy milk, tofu, oil, and other products.\n"
                  "• Although soybeans are a legume, a person with a soy allergy may not be allergic to other legumes, including peanut.\n"
                  "• A soy allergy is most common in infants, however many children do outgrow soy allergy. Soy allergy can also be a lifelong condition. If your child has a soy allergy, consult with your allergist before reintroducing your child to soy products.\n"
                  "• People who are allergic to soy may not need to avoid soy oil. Soy oils tend to be refined enough to remove all of the proteins that can trigger allergic reactions. However, if you have soy allergy, consult with your allergist before eating anything made with soy oils.\n"
                  "• Soy lecithin is a food additive derived from soy bean oil and typically does not contain sufficient protein to cause allergic reactions. However, as soy lecithin is not completely protein-free, some individuals who are allergic to soy may still have a reaction. If you have a soy allergy, consult with your allergist before eating anything containing soy lecithin.",
            ),
            collapsibleSection(
              title: "Allergic reactions to soy",
              content:
                  "• An allergic reaction usually happens within minutes after being exposed to an allergen (e.g., soy), but sometimes it can take place several hours after exposure. Anaphylaxis is the most serious type of allergic reaction.\n\n"
                  "Symptoms of anaphylaxis generally include two or more of the following body systems:\n\n"
                  "• If you have a soy allergy, keep an epinephrine auto-injector (e.g., EpiPen®, ALLERJECT®) with you at all times. Epinephrine is the first-line treatment for severe allergic reactions (anaphylaxis).",
            ),
            collapsibleSection(
              title: "Be allergy-aware: How to avoid soy",
              content:
                  "• Read ingredient labels every time you buy or eat a product. If the label indicates that a product “Contains” or “may contain” soy, do not eat it. If you do not recognize an ingredient, if there is no ingredient list available, or if you don’t understand the language written on the packaging, avoid the product.\n\n"
                  "Do the Triple Check and read the label:\n"
                  "   • Once at the store before buying it.\n"
                  "   • Once when you get home and put it away.\n"
                  "   • Again before you serve or eat the product.\n\n"
                  "• Always carry your epinephrine auto-injector. It’s recommend that if you do not have your auto-injector with you, that you do not eat.\n"
                  "• Check with manufacturers directly if you are not sure if a product is safe for you.\n"
                  "• Be careful when buying products from abroad since labelling rules differ from country to country.\n"
                  "• Watch for cross-contamination, which is when a small amount of a food allergen (e.g., soy) gets into another food accidentally, or when it’s present in saliva, on a surface, or on an object. This small amount of an allergen could cause an allergic reaction.",
            ),
            collapsibleSection(
              title: "Other names for soy",
              content: "• Bean curd (dofu, kori-dofu, soybean curds, tofu)\n"
                  "• Edamame\n"
                  "• Glycine max\n"
                  "• Kinako\n"
                  "• Kouridofu\n"
                  "• Miso\n"
                  "• Hydrolyzed soy protein\n"
                  "• Natto\n"
                  "• Nimame\n"
                  "• Okara\n"
                  "• Soya, soja, soybean, soyabeans\n"
                  "• Soy protein (isolate/concentrate), vegetable protein\n"
                  "• Tempeh\n"
                  "• Textured soy flour (TSF), Textured soy protein (TVP)\n"
                  "• Yuba",
            ),
            collapsibleSection(
              title: "Possible sources of soy",
              content: "• Mono-diglyceride\n"
                  "• Baby formulas\n"
                  "• Baked goods and baking mixes like breads, bread crumbs, cereals, cookies\n"
                  "• Breaded foods\n"
                  "• Bean sprouts\n"
                  "• Beverage mixes\n"
                  "• Chili, pastas, stews, taco filling, tamales\n"
                  "• Canned tuna, minced hams\n"
                  "• Chewing gum\n"
                  "• Chocolate candies and chocolate bars\n"
                  "• Cooking spray, margarine, vegetable shortening, vegetable oil\n"
                  "• Deli meat and processed meats\n"
                  "• Diet drinks, imitation milk\n"
                  "• Dressings, gravies, marinades\n"
                  "• Frozen desserts, soy ice cream, soy pudding, soy yogurt\n"
                  "• Hydrolyzed plant protein (HPP), hydrolyzed soy protein (HSP), hydrolyzed vegetable protein (HVP)\n"
                  "• Imitation crab and other imitation fish\n"
                  "• Monosodium glutamate (MSG)\n"
                  "• Processed and prepared deli meats, e.g. burgers, meat substitutes, patties, wieners\n"
                  "• Vegetarian meat substitutes\n"
                  "• Sauces such as soy, teriyaki and Worcestershire\n"
                  "• Seasonings\n"
                  "• Snack foods like candy, candy bars, popcorn, energy bars\n"
                  "• Soy “cheese”\n"
                  "• Soups, broths and soups mixes, miso soup\n"
                  "• Spreads, dips, mayonnaise, peanut butter\n"
                  "• Thickening agents\n"
                  "• Vegetarian dishes",
            ),
            collapsibleSection(
              title: "Non-food sources of soy",
              content: "• Cosmetics, soaps\n"
                  "• Craft materials, crayons, paint\n"
                  "• Glycerine\n"
                  "• Pet food and milk substitutes for young animals\n"
                  "• Printing ink\n"
                  "• Medications, vitamins, herbal supplements\n"
                  "• Candles",
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget collapsibleSection({required String title, required String content}) {
    return Theme(
      data: ThemeData().copyWith(
        dividerColor: Colors.transparent,
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
      ),
      child: ExpansionTile(
        tilePadding: const EdgeInsets.symmetric(vertical: 5),
        title: Text(
          title,
          style: const TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w700,
            fontSize: 20,
            color: Colors.black,
          ),
        ),
        childrenPadding: const EdgeInsets.only(bottom: 10),
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 10, right: 10),
            child: Text(
              content,
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontSize: 16,
                color: Colors.black87,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// TREENUT ALLERGY DETAIL PAGE

class TreeNutAllergyDetailPage extends StatelessWidget {
  const TreeNutAllergyDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFECFFF8),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.chevron_left, color: Colors.black, size: 30),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: const Text(
          'Tree Nut',
          style: TextStyle(
            fontFamily: 'Poppins',
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            Container(
              width: 120,
              height: 3,
              color: const Color(0xFF6EA08D),
            ),
            const SizedBox(height: 16),
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.asset(
                'assets/images/treenuty.png',
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 20),
            collapsibleSection(
              title: "Quick facts",
              content:
                  "• Tree nuts are considered priority allergens by Health Canada.\n"
                  "• Priority food allergens are the foods that cause the majority of allergic reactions.\n"
                  "• Tree nuts include almonds, Brazil nuts, cashews, hazelnuts, macadamia nuts, pecans, pine nuts (pignolias), pistachio nuts and walnuts.\n"
                  "• Peanuts are part of the legume family and are not considered a tree nut.\n"
                  "• Some people with a tree nut allergy may be allergic to more than one type of tree nut. While others may only be allergic to one type of tree nut.\n"
                  "• If there is no risk of cross-contamination and a type of tree nut is tolerated, there is no reason to exclude that tolerated tree nut – the person can keep it in their diet. If they are unsure which tree nuts they can tolerate, they can speak to their allergist.\n"
                  "• Coconut and nutmeg are not considered tree nuts for the purposes of food allergen labelling in Canada and are not usually restricted from the diet of someone allergic to tree nuts.\n"
                  "• A coconut is a seed of a fruit and nutmeg is obtained from the seeds of a tropical tree.\n"
                  "• However, some people allergic to tree nuts have also reacted to coconut and nutmeg. Consult your allergist before trying coconut- or nutmeg-containing products.",
            ),
            collapsibleSection(
              title: "Allergic reactions to tree nuts",
              content:
                  "• An allergic reaction usually happens within minutes after being exposed to an allergen, but sometimes it can take place several hours after exposure. Anaphylaxis is the most serious type of allergic reaction.\n\n"
                  "Symptoms of anaphylaxis generally include two or more of the following body systems:\n"
                  "• Skin: hives, swelling (face, lips, tongue), itching, warmth, redness\n"
                  "• Respiratory (breathing): coughing, wheezing, shortness of breath, chest pain/tightness, throat tightness, hoarse voice, nasal congestion or hay fever-like symptoms (runny itchy nose and watery eyes, sneezing), trouble swallowing\n"
                  "• Gastrointestinal (stomach): nausea, pain/cramps, vomiting, diarrhea\n"
                  "• Cardiovascular (heart): paler than normal skin colour/blue colour, weak pulse, passing out, dizziness or lightheadedness, shock\n"
                  "• Other: anxiety, sense of doom (the feeling that something bad is about to happen), headache, uterine cramps, metallic taste\n\n"
                  "• If you have an allergy to tree nuts, keep an epinephrine auto-injector (e.g., EpiPen®, ALLERJECT®) with you at all times. Epinephrine is the first-line treatment for severe allergic reactions (anaphylaxis).",
            ),
            collapsibleSection(
              title: "Be Allergy-Aware: How to avoid tree nuts",
              content:
                  "• Read ingredient labels every time you buy or eat a product. If the label indicates that a product “Contains” or “may contain” tree nut, do not eat it. If you do not recognize an ingredient, if there is no ingredient list available, or if you don’t understand the language written on the packaging, avoid the product.\n\n"
                  "According to Health Canada:\n"
                  "• If a tree nut is part of the ingredients, the specific tree nut(s) must be declared by their common name (almond, Brazil nut, etc.) in the list of ingredients or in a separate “contains” statement immediately following the list of ingredients.\n\n"
                  "Do The Triple Check and read the label:\n"
                  "   • Once at the store before buying it.\n"
                  "   • Once when you get home and put it away.\n"
                  "   • Again before you serve or eat the product.\n\n"
                  "• Always carry your epinephrine auto-injector. It’s recommend that if you do not have your auto-injector with you, that you do not eat.\n"
                  "• Check with manufacturers directly if you are not sure if a product is safe for you.\n"
                  "• Be careful when buying imported products, since labelling rules differ from country to country.\n"
                  "• Watch for cross-contamination, which is when a small amount of a food allergen (e.g., almond) gets into another food accidentally, or when it’s present in saliva, on a surface, or on an object. This small amount of an allergen could cause an allergic reaction.",
            ),
            collapsibleSection(
              title: "Common tree nuts",
              content: "• Almonds\n"
                  "• Brazil nuts\n"
                  "• Cashews\n"
                  "• Hazelnuts (filberts)\n"
                  "• Macadamia nuts\n"
                  "• Pecans\n"
                  "• Pine nuts (pinon, pignolias)\n"
                  "• Pistachios\n"
                  "• Walnuts",
            ),
            collapsibleSection(
              title: "Other names for tree nuts",
              content: "• Anacardium nuts\n"
                  "• Mandelonas (a nut-flavoured peanut confection)\n"
                  "• Nut meats\n"
                  "• Queensland nut (macadamia)",
            ),
            collapsibleSection(
              title: "Possible sources of tree nuts",
              content:
                  "• Alcoholic beverages, such as Frangelico, amaretto liqueurs and others\n"
                  "• Baked goods such as biscotti, cakes, cookies, crackers, donuts, granola bars, pastries and pies, baklava, baking mixes\n"
                  "• Barbecue sauce\n"
                  "• Candies, such as calisson, mandelonas, marzipan, some chocolates, chocolate bars\n"
                  "• Cereals, granola, muesli\n"
                  "• Health and Nutritional supplements, such as herbal remedies and vitamins\n"
                  "• Herbal teas\n"
                  "• Hot cocoa and cocoa mixes\n"
                  "• Ice cream, gelato, frozen desserts, sundae toppings, frozen yogurt, pralines\n"
                  "• Main course dishes such as butter chicken, chicken korma, mole sauce, pad thai, satay, chili, other gravy dishes\n"
                  "• Natural flavourings and extracts\n"
                  "• Nut-flavoured coffees, hot cocoa, specialty drinks\n"
                  "• Peanut oil\n"
                  "• Pesto sauce\n"
                  "• Salads and salad dressings\n"
                  "• Smoke flavourings\n"
                  "• Snack food like chips, popcorn, snack mixes, trail mix\n"
                  "• Spreads and Nut butters (e.g., Nutella and gianduia/gianduja)\n"
                  "• Vegetarian dishes",
            ),
            collapsibleSection(
              title: "Non-food sources of tree nuts",
              content: "• Beanbags, kick sacks/hacky sacks\n"
                  "• Bird seed\n"
                  "• Cosmetics, skin and hair care products, lotions, soap, body scrubs, sun screens\n"
                  "• Massage oils\n"
                  "• Pet food\n"
                  "• Sandblasting materials",
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget collapsibleSection({required String title, required String content}) {
    return Theme(
      data: ThemeData().copyWith(
        dividerColor: Colors.transparent,
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
      ),
      child: ExpansionTile(
        tilePadding: const EdgeInsets.symmetric(vertical: 5),
        title: Text(
          title,
          style: const TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w700,
            fontSize: 20,
            color: Colors.black,
          ),
        ),
        childrenPadding: const EdgeInsets.only(bottom: 10),
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 10, right: 10),
            child: Text(
              content,
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontSize: 16,
                color: Colors.black87,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// PEANUT ALLERGY DETAIL PAGE

class PeanutAllergyDetailPage extends StatelessWidget {
  const PeanutAllergyDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFECFFF8),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.chevron_left, color: Colors.black, size: 30),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: const Text(
          'Peanut',
          style: TextStyle(
            fontFamily: 'Poppins',
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            Container(
              width: 120,
              height: 3,
              color: const Color(0xFF6EA08D),
            ),
            const SizedBox(height: 16),
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.asset(
                'assets/images/peanuty.png',
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 20),
            collapsibleSection(
              title: "Quick facts",
              content:
                  "• Peanut allergy is one of the most common food allergies, and it is considered a priority food allergen by Health Canada. Priority food allergens are the foods that cause the majority of allergic reactions.\n"
                  "• Peanuts are a member of the legume family, and not related to tree nuts. A person can be allergic to peanuts and not be allergic to tree nuts, or they can be allergic to both.\n"
                  "• Lupin (or lupine) is an ingredient that is increasingly being used in foods, especially gluten-free products. It is a legume belonging to the same plant family as peanuts, and some people are allergic to both. It is recommended for anyone with a peanut allergy to avoid products containing lupin until they have consulted with their allergist.\n"
                  "• It was once considered that all peanut allergies were lifelong. However, some studies have shown that some children may outgrow their peanut allergy. If your child has peanut allergy, consult with your allergist before reintroducing peanut products.\n"
                  "• Many international cuisines use peanuts in food, including, Indonesian (e.g., satays), Thai (e.g., curries), Vietnamese (e.g. crushed peanut as a topping, spring rolls), Indian (e.g., certain curries), and Chinese (e.g. egg rolls, certain sauces).",
            ),
            collapsibleSection(
              title: "Allergic reactions to peanut",
              content:
                  "• If you have an allergy to peanut, keep an epinephrine auto-injector (e.g., EpiPen®, ALLERJECT®) with you at all times. Epinephrine is the first-line treatment for severe allergic reactions (anaphylaxis).",
            ),
            collapsibleSection(
              title: "Be allergy-aware: How to avoid peanut",
              content:
                  "• Read ingredient labels every time you buy or eat a product. If the label indicates that a product “Contains” or “may contain” peanut, do not eat it. If you do not recognize an ingredient, if there is no ingredient list available, or if you don’t understand the language written on the packaging, avoid the product.\n\n"
                  "Do the Triple Check and read the label:\n"
                  "   • Once at the store before buying it.\n"
                  "   • Once when you get home and put it away.\n"
                  "   • Again before you serve or eat the product.\n\n"
                  "• Always carry your epinephrine auto-injector. It’s recommend that if you do not have your auto-injector with you, that you do not eat.\n"
                  "• Check with manufacturers directly if you are not sure if a product is safe for you.\n"
                  "• Be careful when buying products from abroad since labelling rules differ from country to country.\n"
                  "• Watch for cross-contamination, which is when a small amount of a food allergen (e.g., peanut) gets into another food accidentally, or when it’s present in saliva, on a surface, or on an object. This small amount of an allergen could cause an allergic reaction.",
            ),
            collapsibleSection(
              title: "Other names for peanuts",
              content: "• Arachide\n"
                  "• Arachis oil\n"
                  "• Beer nuts\n"
                  "• Cacahouète/cacahouette/cachuète\n"
                  "• Goober nuts, goober peas\n"
                  "• Ground nuts\n"
                  "• Kernels\n"
                  "• Mandelonas, Nu-Nuts (a nut-flavoured peanut confection)\n"
                  "• Nut meats\n"
                  "• Valencias",
            ),
            collapsibleSection(
              title: "Possible sources of peanuts",
              content:
                  "• Almond & hazelnut paste, icing, glazes, marzipan, nougat\n"
                  "• Asian cuisine such as curries, egg rolls, pad thai, satay, Szechuan and other sauces, gravy, soups\n"
                  "• Baked goods like cakes, cookies, donuts, energy bars, granola bars, pastries\n"
                  "• Candies, such as mandelonas, chocolates, and chocolate bars\n"
                  "• Cereals and granola, granola bars\n"
                  "• Chili\n"
                  "• Chipotle sauce and other Mexican/Latin sauces\n"
                  "• Ice cream and flavoured ice water treats, frozen desserts, frozen yogurts, sundae toppings\n"
                  "• Dried salad dressings and soup mixes\n"
                  "• Hydrolyzed plant protein/ hydrolyzed vegetable protein\n"
                  "• Faux nuts made from re-formed peanut products (Nu-NutsTM)\n"
                  "• Peanut oil\n"
                  "• Snack foods such as dried fruits, chewy fruit snacks, trail mixes, popcorn, pretzels, chips\n"
                  "• Vegetarian meat substitutes\n"
                  "• Edible fruit arrangements",
            ),
            collapsibleSection(
              title: "Non-food sources of peanuts",
              content: "• Ant bait, bird feed, mouse traps\n"
                  "• Cosmetics, hair and skin care products, soap, sunscreen\n"
                  "• Craft materials\n"
                  "• Medications, vitamins, and health supplements\n"
                  "• Mushroom growing media\n"
                  "• Pet foods and pet toys\n"
                  "• Sunscreen and other creams\n"
                  "• Stuffing in children’s toys",
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget collapsibleSection({required String title, required String content}) {
    return Theme(
      data: ThemeData().copyWith(
        dividerColor: Colors.transparent,
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
      ),
      child: ExpansionTile(
        tilePadding: const EdgeInsets.symmetric(vertical: 5),
        title: Text(
          title,
          style: const TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w700,
            fontSize: 20,
            color: Colors.black,
          ),
        ),
        childrenPadding: const EdgeInsets.only(bottom: 10),
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 10, right: 10),
            child: Text(
              content,
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontSize: 16,
                color: Colors.black87,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
// FISH ALLERGY DETAIL PAGE

class FishAllergyDetailPage extends StatelessWidget {
  const FishAllergyDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFECFFF8),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.chevron_left, color: Colors.black, size: 30),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: const Text(
          'Fish',
          style: TextStyle(
            fontFamily: 'Poppins',
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            Container(
              width: 120,
              height: 3,
              color: const Color(0xFF6EA08D),
            ),
            const SizedBox(height: 16),
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.asset(
                'assets/images/fishy.png',
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 20),
            collapsibleSection(
              title: "Quick facts",
              content:
                  "• Fish is considered a priority food allergen by Health Canada. Priority food allergens are the foods that cause the majority of allergic reactions.\n"
                  "• Fish (e.g., trout, salmon), crustaceans (e.g., lobster, shrimp), and molluscs (e.g., scallops, clams) are sometimes collectively referred to as seafood.\n"
                  "• In North America, fish allergies are more predominant in adults, while in countries where fish is a dietary staple, fish allergies are common among both adults and children.\n"
                  "• Allergies to fish are usually lifelong conditions.\n"
                  "• People who are allergic to fish may not need to avoid fish oil supplements. Fish oils supplements on the market tend to be refined enough to remove all of the proteins that can trigger allergic reactions. However, if you have a fish allergy, consult with your allergist before consuming anything made with fish oils.\n"
                  "• People who are allergic to one type of seafood, may not be allergic to other kinds of seafood. Many people are only allergic to a single type of seafood. For example, some people can eat lobster safely, but have allergic reactions to fish.",
            ),
            collapsibleSection(
              title: "Allergic reactions to fish",
              content:
                  "• An allergic reaction usually happens within minutes after being exposed to an allergen (e.g., fish), but sometimes it can take place several hours after exposure. Anaphylaxis is the most serious type of allergic reaction.\n\n"
                  "• Individuals with fish allergy can experience allergic reactions without eating fish. On rare occasions, exposures to fish proteins in cooking vapours (such as steam from cooking fish) and on dishes used to present these foods (like sizzling woks or skillets) can cause an allergic reaction.\n\n"
                  "Symptoms of anaphylaxis generally include two or more of the following body systems:\n\n"
                  "• If you have an allergy to fish, keep an epinephrine auto-injector (e.g., EpiPen®, ALLERJECT®) with you at all times. Epinephrine is the first-line treatment for severe allergic reactions (anaphylaxis).",
            ),
            collapsibleSection(
              title: "Be allergy-aware: How to avoid fish",
              content:
                  "• Read ingredient labels every time you buy or eat a product. If the label indicates that a product “Contains” or “may contain” fish, do not eat it.\n"
                  "• If you do not recognize an ingredient, if there is no ingredient list available, or if you don’t understand the language written on the packaging, avoid the product.\n\n"
                  "Do The Triple Check and read the label:\n"
                  "   • Once at the store before buying it.\n"
                  "   • Once when you get home and put it away.\n"
                  "   • Again before you serve or eat the product.\n\n"
                  "• Always carry your epinephrine auto-injector. It’s recommend that if you do not have your auto-injector with you, that you do not eat.\n"
                  "• Check with manufacturers directly if you are not sure if a product is safe for you.\n"
                  "• Chopped fish products (such as canned tuna) have a high risk for being contaminated with many other types of fish during processing.\n"
                  "• Check with manufacturers directly to see if the product is safe for you even if your allergen is not listed on the ingredient list.\n"
                  "• Be careful when buying products from abroad since labelling rules differ from country to country.\n"
                  "• Watch for cross-contamination, which is when a small amount of a food allergen (e.g., fish) gets into another food accidentally, or when it’s present in saliva, on a surface, or on an object. This small amount of an allergen could cause an allergic reaction.",
            ),
            collapsibleSection(
              title: "Names of common types of fish",
              content: "• Anchovy\n"
                  "• Basa\n"
                  "• Bass\n"
                  "• Bluefish\n"
                  "• Bream\n"
                  "• Carp\n"
                  "• Catfish (channel cat, mud cat)\n"
                  "• Char\n"
                  "• Chub\n"
                  "• Cisco\n"
                  "• Cod\n"
                  "• Eel\n"
                  "• Flounder\n"
                  "• Grouper\n"
                  "• Haddock\n"
                  "• Hake\n"
                  "• Halibut\n"
                  "• Herring\n"
                  "• Mackerel\n"
                  "• Mahi-mahi\n"
                  "• Marlin\n"
                  "• Monkfish (angler fish, lotte)\n"
                  "• Orange roughy\n"
                  "• Perch\n"
                  "• Pickerel (dore, walleye)\n"
                  "• Pike\n"
                  "• Plaice\n"
                  "• Pollock\n"
                  "• Pompano\n"
                  "• Porgy\n"
                  "• Rockfish\n"
                  "• Salmon\n"
                  "• Sardine\n"
                  "• Shark\n"
                  "• Smelt\n"
                  "• Snapper\n"
                  "• Sole\n"
                  "• Sturgeon\n"
                  "• Swordfish\n"
                  "• Tilapia (St. Peter's fish)\n"
                  "• Trout\n"
                  "• Tuna (albacore, bonito)\n"
                  "• Turbot\n"
                  "• White fish\n"
                  "• Whiting",
            ),
            collapsibleSection(
              title: "Other examples of fish",
              content: "• Caviar and roe (unfertilized fish eggs)\n"
                  "• Ceviche\n"
                  "• Gravad Lax\n"
                  "• Kamaboko (imitation crab and lobster meat)\n"
                  "• Lox\n"
                  "• Minced fillets\n"
                  "• Sashimi\n"
                  "• Scrod\n"
                  "• Surimi (used to make imitation crab and lobster meat)\n"
                  "• Sushi\n"
                  "• Tarama (salted carp roe)",
            ),
            collapsibleSection(
              title: "Possible sources of fish",
              content: "• Deli meats, hot dogs\n"
                  "• Dips, spreads, imitation crab/lobster meat\n"
                  "• Combination foods such as fried rice, paella, spring rolls\n"
                  "• Fish mixtures\n"
                  "• Garnishes, e.g. antipasto, caponata (Sicilian relish)\n"
                  "• Gelatin, marshmallows\n"
                  "• Pizza toppings\n"
                  "• Salad dressings\n"
                  "• Sauces, e.g., marinara/puttanesca, Nuoc Mâm, and Worcestershire\n"
                  "• Spreads, e.g. taramasalata\n"
                  "• Soups\n"
                  "• Sushi\n"
                  "• Tarama (roe)\n"
                  "• Wine and beer (used as a fining agent)\n"
                  "• Fried foods (from contaminated frying oil)",
            ),
            collapsibleSection(
              title: "Non-food sources of fish",
              content: "• Fish food\n"
                  "• Lip balm/lip gloss\n"
                  "• Pet food and pet bedding\n"
                  "• Compost or fertilizers\n\n"
                  "Note: These lists are not complete and may change.",
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget collapsibleSection({required String title, required String content}) {
    return Theme(
      data: ThemeData().copyWith(
        dividerColor: Colors.transparent,
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
      ),
      child: ExpansionTile(
        tilePadding: const EdgeInsets.symmetric(vertical: 5),
        title: Text(
          title,
          style: const TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w700,
            fontSize: 20,
            color: Colors.black,
          ),
        ),
        childrenPadding: const EdgeInsets.only(bottom: 10),
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 10, right: 10),
            child: Text(
              content,
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontSize: 16,
                color: Colors.black87,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// SHELLFISH ALLERGY DETAIL PAGE

class ShellfishAllergyDetailPage extends StatelessWidget {
  const ShellfishAllergyDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFECFFF8),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.chevron_left, color: Colors.black, size: 30),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: const Text(
          'Shellfish',
          style: TextStyle(
            fontFamily: 'Poppins',
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            Container(
              width: 120,
              height: 3,
              color: const Color(0xFF6EA08D),
            ),
            const SizedBox(height: 16),
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.asset(
                'assets/images/shellfishy.png',
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 20),
            collapsibleSection(
              title: "Quick facts",
              content:
                  "• Crustaceans are aquatic animals that have jointed legs, a hard shell, and no backbone. Examples include crab, crayfish, lobster, prawns, and shrimp.\n"
                  "• Most molluscs have a hinged two-part shell and include clams, mussels, oysters, and scallops. It can also include various types of octopus, snail, and squid.\n"
                  "• Crustaceans and molluscs, sometimes collectively referred to as shellfish, are considered priority food allergens by Health Canada. Priority food allergens are the foods that cause the majority of allergic reactions.\n"
                  "• Fish (e.g., trout, salmon), crustaceans (e.g., lobster, shrimp), and molluscs (e.g., scallops, clams) are sometimes collectively referred to as seafood.\n"
                  "• Shellfish allergies predominately affect adults and are less common among young children. These allergies tend to develop later in life than the common childhood allergies.\n"
                  "• Allergies to shellfish are usually lifelong.\n"
                  "• People who are allergic to one type of seafood, may not be allergic to other kinds of seafood. Many people are only allergic to a single type of seafood. For example, some people can eat fish safely, but have allergic reactions to shellfish like lobster or crab.\n"
                  "• If you are allergic to one type of shellfish (like molluscs), consult your allergist before trying other types (like crustaceans).",
            ),
            collapsibleSection(
              title: "Allergic reactions to shellfish",
              content:
                  "• Individuals with shellfish allergies can experience allergic reactions without eating these foods. On rare occasions, exposures to proteins in cooking vapours (such as steam from boiling lobsters) and on dishes used to present these foods (like sizzling woks or skillets) can cause an allergic reaction.\n\n"
                  "• If you have an allergy to shellfish, keep an epinephrine auto-injector (e.g., EpiPen®, ALLERJECT®) with you at all times. Epinephrine is the first-line treatment for severe allergic reactions (anaphylaxis).",
            ),
            collapsibleSection(
              title: "Be allergy-aware: How to avoid shellfish",
              content:
                  "• Read ingredient labels every time you buy or eat a product. If the label indicates that a product “Contains” or “may contain” shellfish, do not eat it.\n"
                  "• Health Canada notes the following:\n"
                  "• If shellfish is part of the food, the specific species/type must be declared in the list of ingredients or in a separate “contains” statement using their common names (e.g., lobster, crab, clam, oyster).\n"
                  "• The \"may contain\" label might contain the specific type (e.g., \"may contain shrimp\") or a general statement (e.g., \"may contain crustaceans or molluscs\").\n"
                  "• If you do not recognize an ingredient, if there is no ingredient list available, or if you don’t understand the language written on the packaging, avoid the product.\n\n"
                  "Do The Triple Check and read the label:\n"
                  "   • Once at the store before buying it.\n"
                  "   • Once when you get home and put it away.\n"
                  "   • Again before you serve or eat the product.\n\n"
                  "• Always carry your epinephrine auto-injector. It’s recommend that if you do not have your auto-injector with you, that you do not eat.\n"
                  "• Check with manufacturers directly if you are not sure if a product is safe for you.\n"
                  "• Be careful when buying products from abroad since labelling rules differ from country to country.\n"
                  "• Watch for cross-contamination, which is when a small amount of a food allergen (e.g., shrimp) gets into another food accidentally, or when it’s present in saliva, on a surface, or on an object. This small amount of an allergen could cause an allergic reaction.",
            ),
            collapsibleSection(
              title: "Common names for shellfish",
              content: "• Crab\n"
                  "• Crayfish (crawfish, écrivisse)\n"
                  "• Lobster (langouste, langoustine, coral, tomalley)\n"
                  "• Prawns\n"
                  "• Shrimp (crevette)\n"
                  "• Abalone\n"
                  "• Clam\n"
                  "• Cockle\n"
                  "• Conch\n"
                  "• Geoducks\n"
                  "• Limpets\n"
                  "• Mussels\n"
                  "• Octopus\n"
                  "• Oysters\n"
                  "• Periwinkle\n"
                  "• Quahaugs\n"
                  "• Scallops\n"
                  "• Snails (escargot)\n"
                  "• Squid (calamari)\n"
                  "• Whelks",
            ),
            collapsibleSection(
              title: "Other examples of shellfish",
              content: "• Ceviche\n"
                  "• Sashimi\n"
                  "• Scrod\n"
                  "• Surimi (used to make imitation crab and lobster meat)\n"
                  "• Sushi",
            ),
            collapsibleSection(
              title: "Possible sources of shellfish",
              content: "• Dips and spreads\n"
                  "• Combination foods such as fried rice, paella, spring rolls (from rolls or sauce)\n"
                  "• Fried foods (from contaminated frying oil)\n"
                  "• Garnishes, e.g. antipasto, caponata (Sicilian relish)\n"
                  "• Salad dressings\n"
                  "• Sauces, e.g. alle vongole, marinara, oyster sauce\n"
                  "• Soups\n"
                  "• Sushi\n"
                  "• Wine and beer (used as a fining agent)",
            ),
            collapsibleSection(
              title: "Non-food sources of shellfish",
              content: "• Lip balm/lip gloss\n"
                  "• Pet food and pet bedding\n"
                  "• Compost or fertilizers",
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget collapsibleSection({required String title, required String content}) {
    return Theme(
      data: ThemeData().copyWith(
        dividerColor: Colors.transparent,
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
      ),
      child: ExpansionTile(
        tilePadding: const EdgeInsets.symmetric(vertical: 5),
        title: Text(
          title,
          style: const TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w700,
            fontSize: 20,
            color: Colors.black,
          ),
        ),
        childrenPadding: const EdgeInsets.only(bottom: 10),
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 10, right: 10),
            child: Text(
              content,
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontSize: 16,
                color: Colors.black87,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
