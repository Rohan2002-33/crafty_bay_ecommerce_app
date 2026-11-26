import '../models/category_model.dart';
import '../models/product_model.dart';

class AppCatalog {
  AppCatalog._();

  static const List<CategoryModel> categories = [
    CategoryModel(
      id: 'cat_electronics',
      title: 'Electronics',
      icon: 'https://cdn-icons-png.flaticon.com/512/3659/3659898.png',
    ),
    CategoryModel(
      id: 'cat_food',
      title: 'Food',
      icon: 'https://cdn-icons-png.flaticon.com/512/3082/3082055.png',
    ),
    CategoryModel(
      id: 'cat_fashion',
      title: 'Fashion',
      icon: 'https://cdn-icons-png.flaticon.com/512/3050/3050239.png',
    ),
    CategoryModel(
      id: 'cat_furniture',
      title: 'Furniture',
      icon: 'https://cdn-icons-png.flaticon.com/512/3030/3030336.png',
    ),
    CategoryModel(
      id: 'cat_books',
      title: 'Books',
      icon: 'https://cdn-icons-png.flaticon.com/512/3389/3389081.png',
    ),
    CategoryModel(
      id: 'cat_sports',
      title: 'Sports',
      icon: 'https://cdn-icons-png.flaticon.com/512/857/857455.png',
    ),
    CategoryModel(
      id: 'cat_beauty',
      title: 'Beauty',
      icon: 'https://cdn-icons-png.flaticon.com/512/1005/1005663.png',
    ),
    CategoryModel(
      id: 'cat_appliances',
      title: 'Appliances',
      icon: 'https://cdn-icons-png.flaticon.com/512/1261/1261143.png',
    ),
  ];

  static const List<Product> products = [
    // ==========================================
    // 1. ELECTRONICS
    // ==========================================
    Product(
      id: 'elec_mac_mini_m4',
      title: 'Apple Mac Mini M4',
      brand: 'Apple',
      categoryTitle: 'Electronics',
      categoryId: 'cat_electronics',
      currentPrice: 699.0,
      regularPrice: 799.0,
      rating: 4.9,
      photos: [
        'https://mcsolution.com.bd/wp-content/uploads/2024/10/mac-mini-m4-2024-price-in-Bangladesh-MC-Solution-BD-2.webp',
        'https://images.unsplash.com/photo-1517059224940-d4af9eec41b7?w=600&auto=format&fit=crop&q=80',
      ],
      colors: ['#D1D5DB', '#374151'],
      sizes: ['256GB', '512GB', '1TB'],
      description:
          'The all-new Mac mini powered by the M4 chip delivers extraordinary performance in an impossibly small 5x5 inch frame. Featuring front-facing USB-C ports, Thunderbolt 4 connectivity, and built for Apple Intelligence.',
      tags: ['popular', 'special', 'electronics'],
    ),
    Product(
      id: 'elec_sony_headphones',
      title: 'Sony WH-1000XM5 Wireless Headphones',
      brand: 'Sony',
      categoryTitle: 'Electronics',
      categoryId: 'cat_electronics',
      currentPrice: 349.0,
      regularPrice: 399.0,
      rating: 4.8,
      photos: [
        'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?w=600&auto=format&fit=crop&q=80',
        'https://images.unsplash.com/photo-1484704849700-f032a568e944?w=600&auto=format&fit=crop&q=80',
      ],
      colors: ['#1F2937', '#E5E7EB', '#1E3A8A'],
      sizes: ['Standard'],
      description:
          'Industry-leading noise canceling with two processors and 8 microphones. Magnificent sound engineered to perfection with the new Integrated Processor V1 and carbon fiber driver unit.',
      tags: ['popular', 'electronics'],
    ),
    Product(
      id: 'elec_samsung_monitor',
      title: 'Samsung 32" 4K UHD Curved Monitor',
      brand: 'Samsung',
      categoryTitle: 'Electronics',
      categoryId: 'cat_electronics',
      currentPrice: 399.0,
      regularPrice: 450.0,
      rating: 4.7,
      photos: [
        'https://images.unsplash.com/photo-1527443224154-c4a3942d3acf?w=600&auto=format&fit=crop&q=80',
      ],
      colors: ['#111827', '#F3F4F6'],
      sizes: ['27 Inch', '32 Inch'],
      description:
          'Ultra-crisp 4K UHD resolution with 1500R curved screen for immersive productivity and gaming. Built-in smart apps, HDR10 support, and USB-C single cable connectivity.',
      tags: ['special', 'electronics'],
    ),
    Product(
      id: 'elec_logitech_mouse',
      title: 'Logitech MX Master 3S Mouse',
      brand: 'Logitech',
      categoryTitle: 'Electronics',
      categoryId: 'cat_electronics',
      currentPrice: 99.0,
      regularPrice: 119.0,
      rating: 4.9,
      photos: [
        'https://images.unsplash.com/photo-1615663245857-ac93bb7c39e7?w=600&auto=format&fit=crop&q=80',
      ],
      colors: ['#374151', '#D1D5DB'],
      sizes: ['Ergonomic'],
      description:
          'An icon remastered. Feel every moment of your workflow with even more precision, tactile click, and quiet performance with 8,000 DPI track-on-glass sensor and MagSpeed scrolling.',
      tags: ['popular', 'new', 'electronics'],
    ),
    Product(
      id: 'elec_apple_watch',
      title: 'Apple Watch Series 9 GPS 45mm',
      brand: 'Apple',
      categoryTitle: 'Electronics',
      categoryId: 'cat_electronics',
      currentPrice: 399.0,
      regularPrice: 429.0,
      rating: 4.8,
      photos: [
        'https://images.unsplash.com/photo-1546868871-7041f2a55e12?w=600&auto=format&fit=crop&q=80',
      ],
      colors: ['#111827', '#C2410C', '#E5E7EB'],
      sizes: ['41mm', '45mm'],
      description:
          'Smarter, brighter, and mightier. Powered by the S9 SiP, featuring Double Tap gesture control, always-on Retina display up to 2000 nits, and advanced health and workout tracking.',
      tags: ['new', 'electronics'],
    ),

    // ==========================================
    // 2. FOOD
    // ==========================================
    Product(
      id: 'food_honeycrisp_apples',
      title: 'Organic Honeycrisp Apples 1kg',
      brand: 'FreshFarm',
      categoryTitle: 'Food',
      categoryId: 'cat_food',
      currentPrice: 8.0,
      regularPrice: 12.0,
      rating: 4.8,
      photos: [
        'https://images.unsplash.com/photo-1560806887-1e4cd0b6cbd6?w=600&auto=format&fit=crop&q=80',
      ],
      colors: ['#DC2626', '#16A34A'],
      sizes: ['1kg', '2kg', '5kg'],
      description:
          'Fresh, juicy, and crisp organic Honeycrisp apples harvested from sustainable orchards. High in dietary fiber and essential vitamins, perfect for healthy snacking.',
      tags: ['popular', 'food'],
    ),
    Product(
      id: 'food_arabica_coffee',
      title: 'Artisan Arabica Coffee Beans 500g',
      brand: 'RoastMaster',
      categoryTitle: 'Food',
      categoryId: 'cat_food',
      currentPrice: 18.0,
      regularPrice: 22.0,
      rating: 4.9,
      photos: [
        'https://images.unsplash.com/photo-1559056199-641a0ac8b55e?w=600&auto=format&fit=crop&q=80',
      ],
      colors: ['#78350F'],
      sizes: ['250g', '500g', '1kg'],
      description:
          '100% specialty grade Arabica beans freshly roasted in small batches. Rich tasting notes of dark chocolate, caramel, and subtle citrus acidity.',
      tags: ['special', 'food'],
    ),
    Product(
      id: 'food_olive_oil',
      title: 'Extra Virgin Olive Oil 750ml',
      brand: 'Mediterranean Gold',
      categoryTitle: 'Food',
      categoryId: 'cat_food',
      currentPrice: 22.0,
      regularPrice: 26.0,
      rating: 4.9,
      photos: [
        'https://images.unsplash.com/photo-1474979266404-7eaacbcd87c5?w=600&auto=format&fit=crop&q=80',
      ],
      colors: ['#65A30D'],
      sizes: ['500ml', '750ml', '1L'],
      description:
          'Authentic Mediterranean extra virgin olive oil obtained directly from hand-picked olives using purely mechanical, cold-press extraction for maximum polyphenols and flavor.',
      tags: ['popular', 'food'],
    ),
    Product(
      id: 'food_dark_chocolate',
      title: 'Swiss Dark Chocolate 85% Cocoa',
      brand: 'Chocolatier',
      categoryTitle: 'Food',
      categoryId: 'cat_food',
      currentPrice: 6.0,
      regularPrice: 8.0,
      rating: 4.8,
      photos: [
        'https://images.unsplash.com/photo-1548907040-4baa42d10919?w=600&auto=format&fit=crop&q=80',
      ],
      colors: ['#451A03'],
      sizes: ['100g', 'Pack of 3'],
      description:
          'Pure master-crafted Swiss dark chocolate with 85% cocoa solids. Decadent, smooth, low sugar, and rich in natural antioxidants.',
      tags: ['new', 'food'],
    ),

    // ==========================================
    // 3. FASHION
    // ==========================================
    Product(
      id: 'fash_crafty_shoe_special',
      title: 'Happy New Year Special Deal Shoe 30%',
      brand: 'CraftyBay Sport',
      categoryTitle: 'Fashion',
      categoryId: 'cat_fashion',
      currentPrice: 100.0,
      regularPrice: 150.0,
      rating: 4.8,
      photos: [
        'assets/images/shoe.png',
        'https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=600&auto=format&fit=crop&q=80',
      ],
      colors: ['#1E88E5', '#E53935', '#757575', '#212121'],
      sizes: ['40', '41', '42', '43', '44'],
      description:
          'The signature CraftyBay Happy New Year Special Deal running shoe. Designed with ultra-breathable mesh upper, dynamic flywire cables for lockdown, and a responsive flex-groove phylon sole.',
      tags: ['popular', 'special', 'new', 'fashion'],
    ),
    Product(
      id: 'fash_nike_pegasus',
      title: 'Nike Air Zoom Pegasus Running Shoes',
      brand: 'Nike',
      categoryTitle: 'Fashion',
      categoryId: 'cat_fashion',
      currentPrice: 130.0,
      regularPrice: 160.0,
      rating: 4.9,
      photos: [
        'https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=600&auto=format&fit=crop&q=80',
      ],
      colors: ['#DC2626', '#1F2937', '#2563EB'],
      sizes: ['40', '41', '42', '43', '44'],
      description:
          'A springy ride for any run. The Pegasus features dual Nike Zoom Air units and React foam for responsive cushioning and lightweight durability across miles.',
      tags: ['popular', 'fashion'],
    ),
    Product(
      id: 'fash_oxford_shirt',
      title: 'Men\'s Premium Oxford Cotton Shirt',
      brand: 'Classic Outfitters',
      categoryTitle: 'Fashion',
      categoryId: 'cat_fashion',
      currentPrice: 45.0,
      regularPrice: 65.0,
      rating: 4.7,
      photos: [
        'https://images.unsplash.com/photo-1596755094514-f87e34085b2c?w=600&auto=format&fit=crop&q=80',
      ],
      colors: ['#93C5FD', '#FFFFFF', '#1E3A8A'],
      sizes: ['S', 'M', 'L', 'XL', 'XXL'],
      description:
          'Tailored from 100% two-ply combed cotton. Features a classic button-down collar, box pleat with hanger loop, and mother-of-pearl buttons for smart-casual perfection.',
      tags: ['special', 'fashion'],
    ),
    Product(
      id: 'fash_leather_handbag',
      title: 'Structured Italian Leather Handbag',
      brand: 'Milano Luxe',
      categoryTitle: 'Fashion',
      categoryId: 'cat_fashion',
      currentPrice: 120.0,
      regularPrice: 160.0,
      rating: 4.9,
      photos: [
        'https://images.unsplash.com/photo-1584917865442-de89df76afd3?w=600&auto=format&fit=crop&q=80',
      ],
      colors: ['#78350F', '#111827', '#E5E7EB'],
      sizes: ['Medium', 'Large'],
      description:
          'Handcrafted from full-grain vegetable-tanned Italian leather with gold-tone hardware. Includes detachable shoulder strap, zip partition, and protective metal feet.',
      tags: ['new', 'fashion'],
    ),
    Product(
      id: 'fash_denim_jacket',
      title: 'Vintage Washed Slim Denim Jacket',
      brand: 'Denim Co',
      categoryTitle: 'Fashion',
      categoryId: 'cat_fashion',
      currentPrice: 75.0,
      regularPrice: 95.0,
      rating: 4.8,
      photos: [
        'https://images.unsplash.com/photo-1576995853123-5a10305d93c0?w=600&auto=format&fit=crop&q=80',
      ],
      colors: ['#2563EB', '#1E293B'],
      sizes: ['S', 'M', 'L', 'XL'],
      description:
          'A timeless trucker jacket crafted from 100% heavyweight cotton denim. Classic button flap chest pockets, adjustable waist tabs, and copper shank buttons.',
      tags: ['special', 'fashion'],
    ),

    // ==========================================
    // 4. FURNITURE
    // ==========================================
    Product(
      id: 'furn_ergonomic_chair',
      title: 'Ergonomic High-Back Office Chair',
      brand: 'ComfortPro',
      categoryTitle: 'Furniture',
      categoryId: 'cat_furniture',
      currentPrice: 195.0,
      regularPrice: 260.0,
      rating: 4.9,
      photos: [
        'https://images.unsplash.com/photo-1580481077195-c22ae2804b32?w=600&auto=format&fit=crop&q=80',
      ],
      colors: ['#111827', '#6B7280', '#0284C7'],
      sizes: ['Standard'],
      description:
          'Designed for all-day posture support with 3D dynamic lumbar adjustment, breathable German mesh, 4D armrests, and synchronous tilt reclining mechanism up to 135 degrees.',
      tags: ['popular', 'furniture'],
    ),
    Product(
      id: 'furn_queen_bed',
      title: 'Solid Oak Queen Bed Frame',
      brand: 'Nordic Craft',
      categoryTitle: 'Furniture',
      categoryId: 'cat_furniture',
      currentPrice: 450.0,
      regularPrice: 580.0,
      rating: 4.8,
      photos: [
        'https://images.unsplash.com/photo-1505693416388-ac5ce068fe85?w=600&auto=format&fit=crop&q=80',
      ],
      colors: ['#B45309', '#78350F'],
      sizes: ['Single', 'Queen', 'King'],
      description:
          'Handcrafted from sustainably sourced solid Malaysian oak with integrated heavy-duty slat support system. Minimalist headboard with rounded corners and non-squeak joinery.',
      tags: ['special', 'furniture'],
    ),
    Product(
      id: 'furn_velvet_sofa',
      title: 'Modern Velvet 3-Seater Sofa',
      brand: 'LoungeLiving',
      categoryTitle: 'Furniture',
      categoryId: 'cat_furniture',
      currentPrice: 520.0,
      regularPrice: 680.0,
      rating: 4.8,
      photos: [
        'https://images.unsplash.com/photo-1555041469-a586c61ea9bc?w=600&auto=format&fit=crop&q=80',
      ],
      colors: ['#065F46', '#1E3A8A', '#374151'],
      sizes: ['2-Seater', '3-Seater'],
      description:
          'Timeless button-tufted design upholstered in stain-resistant performance velvet. Solid eucalyptus frame with tapered brass-capped legs and high-resiliency foam cushions.',
      tags: ['new', 'furniture'],
    ),
    Product(
      id: 'furn_coffee_table',
      title: 'Minimalist Solid Wood Coffee Table',
      brand: 'Nordic Craft',
      categoryTitle: 'Furniture',
      categoryId: 'cat_furniture',
      currentPrice: 140.0,
      regularPrice: 180.0,
      rating: 4.7,
      photos: [
        'https://images.unsplash.com/photo-1533090161767-e6ffed986c88?w=600&auto=format&fit=crop&q=80',
      ],
      colors: ['#D97706', '#FFFFFF'],
      sizes: ['Round 80cm', 'Oval 100cm'],
      description:
          'Mid-century inspired minimalist coffee table crafted with natural walnut veneer and solid beech wood angled legs. Smooth scratch-resistant satin lacquer finish.',
      tags: ['popular', 'furniture'],
    ),

    // ==========================================
    // 5. BOOKS
    // ==========================================
    Product(
      id: 'book_recharge_battery',
      title: 'রিচার্জ ইয়োর ডাউন ব্যাটারি',
      brand: 'Wafilife',
      categoryTitle: 'Books',
      categoryId: 'cat_books',
      currentPrice: 10.0,
      regularPrice: 15.0,
      rating: 4.9,
      photos: [
        'https://wafilife-media.wafilife.com/uploads/2020/11/%E0%A6%B0%E0%A6%BF%E0%A6%9A%E0%A6%BE%E0%A6%B0%E0%A7%8D%E0%A6%9C-%E0%A6%87%E0%A7%9F%E0%A7%8B%E0%A6%B0-%E0%A6%A1%E0%A6%BE%E0%A6%89%E0%A6%A8-%E0%A6%AC%E0%A7%8D%E0%A6%AF%E0%A6%BE%E0%A6%9F%E0%A6%BE%E0%A6%B0%E0%A6%BF-250x386.jpg',
      ],
      colors: ['#DC2626'],
      sizes: ['Hardcover', 'Paperback'],
      description:
          'ঝিমিয়ে পড়া আত্মবিশ্বাসকে চাঙ্গা করার অসাধারণ অনুপ্রেরণামূলক বই। লেখক জীবনের কঠিন মুহূর্তে ইতিবাচক চিন্তা ও শক্তি ফিরে পাওয়ার বাস্তবসম্মত সমাধান তুলে ধরেছেন।',
      tags: ['popular', 'special', 'books'],
    ),
    Product(
      id: 'book_sohoj_algorithm',
      title: 'সহজ ভাষায় অ্যালগরিদম',
      brand: 'Rokomari',
      categoryTitle: 'Books',
      categoryId: 'cat_books',
      currentPrice: 12.0,
      regularPrice: 18.0,
      rating: 4.9,
      photos: [
        'https://ds.rokomari.store/rokomari110/ProductNew20190903/260X372/Sohoj_Bhashay_Algorithm-Ihsanul_Islam-ab6e3-227461.jpg',
      ],
      colors: ['#2563EB'],
      sizes: ['Paperback'],
      description:
          'কম্পিউটার বিজ্ঞানের প্রাণ হলো অ্যালগরিদম। বাংলা ভাষায় অত্যন্ত সহজ ও সাবলীল উদাহরণসহ কমপ্লেক্সিটি, সর্টিং, সার্চিং এবং গ্রাফ অ্যালগরিদম শেখার সেরা বই।',
      tags: ['popular', 'books'],
    ),
    Product(
      id: 'book_java_programming',
      title: 'জাভা প্রোগ্রামিং',
      brand: 'Wafilife',
      categoryTitle: 'Books',
      categoryId: 'cat_books',
      currentPrice: 15.0,
      regularPrice: 22.0,
      rating: 4.8,
      photos: [
        'https://wafilife-media.wafilife.com/uploads/2020/01/java-250x341.png',
      ],
      colors: ['#EA580C'],
      sizes: ['Paperback'],
      description:
          'জাভা ল্যাঙ্গুয়েজের অবজেক্ট ওরিয়েন্টেড প্রোগ্রামিং (OOP), মাল্টিথ্রেডিং, কালেকশন ফ্রেমওয়ার্ক এবং সফটওয়্যার ডেভেলপমেন্টের পূর্ণাঙ্গ গাইড।',
      tags: ['special', 'books'],
    ),
    Product(
      id: 'book_python_programming',
      title: 'কম্পিউটার প্রোগ্রামিং (পাইথন)',
      brand: 'Rokomari',
      categoryTitle: 'Books',
      categoryId: 'cat_books',
      currentPrice: 14.0,
      regularPrice: 20.0,
      rating: 4.9,
      photos: [
        'https://ds.rokomari.store/rokomari110/ProductNew20190903/260X372/Python_Programming-Tamim_Shahriar_Subeen-e98be-137574.jpg',
      ],
      colors: ['#059669'],
      sizes: ['Paperback'],
      description:
          'তামিম শাহরিয়ার সুবীনের জনপ্রিয় পাইথন প্রোগ্রামিং শেখার বই। প্রোগ্রামিংয়ের মৌলিক ধারণা, সিনট্যাক্স, লুপ, ফাংশন ও প্রবলেম সলভিংয়ের সুস্পষ্ট ব্যাখ্যা।',
      tags: ['new', 'books'],
    ),

    // ==========================================
    // 6. SPORTS
    // ==========================================
    Product(
      id: 'sport_tennis_racket',
      title: 'Wilson Pro Staff 97 Tennis Racket',
      brand: 'Wilson',
      categoryTitle: 'Sports',
      categoryId: 'cat_sports',
      currentPrice: 219.0,
      regularPrice: 260.0,
      rating: 4.9,
      photos: [
        'https://images.unsplash.com/photo-1617083934555-ac7d4fed8880?w=600&auto=format&fit=crop&q=80',
      ],
      colors: ['#111827', '#DC2626'],
      sizes: ['Grip 2 (4 1/4)', 'Grip 3 (4 3/8)'],
      description:
          'Engineered for ultimate precision and feel. Features Braid 45 construction for enhanced pocketing and exceptional stability at ball impact.',
      tags: ['popular', 'sports'],
    ),
    Product(
      id: 'sport_soccer_ball',
      title: 'Adidas Pro Match Official Soccer Ball',
      brand: 'Adidas',
      categoryTitle: 'Sports',
      categoryId: 'cat_sports',
      currentPrice: 45.0,
      regularPrice: 60.0,
      rating: 4.8,
      photos: [
        'https://images.unsplash.com/photo-1511886929837-354d827aae26?w=600&auto=format&fit=crop&q=80',
      ],
      colors: ['#FFFFFF', '#2563EB'],
      sizes: ['Size 4', 'Size 5'],
      description:
          'Thermally bonded seamless surface for more predictable trajectory, better touch, and lower water uptake. FIFA Quality Pro certified.',
      tags: ['special', 'sports'],
    ),
    Product(
      id: 'sport_yoga_mat',
      title: 'Anti-Slip High-Density Yoga Mat 6mm',
      brand: 'FitLife',
      categoryTitle: 'Sports',
      categoryId: 'cat_sports',
      currentPrice: 25.0,
      regularPrice: 35.0,
      rating: 4.8,
      photos: [
        'https://images.unsplash.com/photo-1601925260368-ae2f83cf8b7f?w=600&auto=format&fit=crop&q=80',
      ],
      colors: ['#7C3AED', '#0D9488', '#EC4899'],
      sizes: ['6mm Thick', '8mm Thick'],
      description:
          'Eco-friendly non-toxic TPE dual-layer mat with laser-engraved alignment lines. Provides optimal cushioning for joints and textured anti-slip grip on all floors.',
      tags: ['popular', 'sports'],
    ),
    Product(
      id: 'sport_speed_rope',
      title: 'Pro Speed Cable Jump Rope with Bearings',
      brand: 'FitLife',
      categoryTitle: 'Sports',
      categoryId: 'cat_sports',
      currentPrice: 15.0,
      regularPrice: 22.0,
      rating: 4.7,
      photos: [
        'https://images.unsplash.com/photo-1434596922112-19c563067271?w=600&auto=format&fit=crop&q=80',
      ],
      colors: ['#1F2937', '#DC2626'],
      sizes: ['Adjustable 3M'],
      description:
          '360-degree dual ball-bearing system ensures frictionless high-speed rotation for double-unders, cardio conditioning, and boxing workouts.',
      tags: ['new', 'sports'],
    ),

    // ==========================================
    // 7. BEAUTY
    // ==========================================
    Product(
      id: 'beauty_loreal_serum',
      title: 'L\'Oreal Revitalift Hyaluronic Acid Serum',
      brand: 'L\'Oreal Paris',
      categoryTitle: 'Beauty',
      categoryId: 'cat_beauty',
      currentPrice: 28.0,
      regularPrice: 36.0,
      rating: 4.9,
      photos: [
        'https://images.unsplash.com/photo-1620916566398-39f1143ab7be?w=600&auto=format&fit=crop&q=80',
      ],
      colors: ['#818CF8'],
      sizes: ['30ml', '50ml'],
      description:
          'Intensive hydrating serum with 1.5% pure Hyaluronic Acid. Visibly plumps skin and reduces fine wrinkles within 1 week. Fragrance-free and dermatologist tested.',
      tags: ['popular', 'beauty'],
    ),
    Product(
      id: 'beauty_chanel_perfume',
      title: 'Chanel Coco Mademoiselle Eau de Parfum',
      brand: 'Chanel',
      categoryTitle: 'Beauty',
      categoryId: 'cat_beauty',
      currentPrice: 145.0,
      regularPrice: 165.0,
      rating: 4.9,
      photos: [
        'https://images.unsplash.com/photo-1541643600914-78b084683601?w=600&auto=format&fit=crop&q=80',
      ],
      colors: ['#F472B6'],
      sizes: ['50ml', '100ml'],
      description:
          'An irresistible oriental fragrance with vibrant orange top notes, transparent rose and jasmine heart, and warm patchouli and vetiver base.',
      tags: ['special', 'beauty'],
    ),
    Product(
      id: 'beauty_cerave_cleanser',
      title: 'CeraVe Hydrating Facial Cleanser 473ml',
      brand: 'CeraVe',
      categoryTitle: 'Beauty',
      categoryId: 'cat_beauty',
      currentPrice: 18.0,
      regularPrice: 24.0,
      rating: 4.8,
      photos: [
        'https://images.unsplash.com/photo-1556228720-195a672e8a03?w=600&auto=format&fit=crop&q=80',
      ],
      colors: ['#10B981'],
      sizes: ['236ml', '473ml'],
      description:
          'Formulated with 3 essential ceramides and hyaluronic acid to cleanse, hydrate, and help restore the protective skin barrier without stripping moisture.',
      tags: ['popular', 'beauty'],
    ),
    Product(
      id: 'beauty_matte_lipstick',
      title: 'Maybelline SuperStay Matte Ink Lipstick',
      brand: 'Maybelline',
      categoryTitle: 'Beauty',
      categoryId: 'cat_beauty',
      currentPrice: 12.0,
      regularPrice: 16.0,
      rating: 4.7,
      photos: [
        'https://images.unsplash.com/photo-1586495777744-4413f21062fa?w=600&auto=format&fit=crop&q=80',
      ],
      colors: ['#BE123C', '#9F1239', '#881337'],
      sizes: ['5ml Standard'],
      description:
          'Flawless matte liquid lipstick lasting up to 16 hours. Features a precise arrow applicator for smooth, transfer-proof, high-pigment coverage.',
      tags: ['new', 'beauty'],
    ),

    // ==========================================
    // 8. APPLIANCES
    // ==========================================
    Product(
      id: 'app_philips_airfryer',
      title: 'Philips Digital Airfryer XXL 1.4kg',
      brand: 'Philips',
      categoryTitle: 'Appliances',
      categoryId: 'cat_appliances',
      currentPrice: 180.0,
      regularPrice: 230.0,
      rating: 4.9,
      photos: [
        'https://images.unsplash.com/photo-1584269600464-37b1b58a9fe7?w=600&auto=format&fit=crop&q=80',
      ],
      colors: ['#1F2937'],
      sizes: ['4.1L', '7.2L XXL'],
      description:
          'Rapid Air Technology fries with up to 90% less fat. Features 16-in-1 cooking functions, digital touch screen with 7 presets, and dishwasher safe components.',
      tags: ['popular', 'appliances'],
    ),
    Product(
      id: 'app_dyson_vacuum',
      title: 'Dyson V12 Detect Slim Cordless Vacuum',
      brand: 'Dyson',
      categoryTitle: 'Appliances',
      categoryId: 'cat_appliances',
      currentPrice: 599.0,
      regularPrice: 699.0,
      rating: 4.9,
      photos: [
        'https://images.unsplash.com/photo-1558317374-067fb5f30001?w=600&auto=format&fit=crop&q=80',
      ],
      colors: ['#F59E0B', '#9CA3AF'],
      sizes: ['V12 Slim', 'V12 Total Clean'],
      description:
          'Dyson\'s lightest intelligent cordless vacuum with laser illumination that reveals invisible dust. Up to 60 minutes run time with piezo sensor dirt measurement.',
      tags: ['special', 'appliances'],
    ),
    Product(
      id: 'app_nespresso_coffee',
      title: 'Nespresso Vertuo Pop Espresso Machine',
      brand: 'Nespresso',
      categoryTitle: 'Appliances',
      categoryId: 'cat_appliances',
      currentPrice: 129.0,
      regularPrice: 159.0,
      rating: 4.8,
      photos: [
        'https://images.unsplash.com/photo-1517668808822-9ebb02ae2a0e?w=600&auto=format&fit=crop&q=80',
      ],
      colors: ['#111827', '#EAB308', '#DC2626'],
      sizes: ['Compact Vertuo'],
      description:
          'Centrifusion extraction technology spins up to 4000 rpm to blend ground coffee with water and produce the signature silky crema. Brews 4 cup sizes at the touch of a button.',
      tags: ['popular', 'new', 'appliances'],
    ),
    Product(
      id: 'app_microwave_oven',
      title: 'Panasonic 32L Inverter Convection Microwave',
      brand: 'Panasonic',
      categoryTitle: 'Appliances',
      categoryId: 'cat_appliances',
      currentPrice: 240.0,
      regularPrice: 290.0,
      rating: 4.7,
      photos: [
        'https://images.unsplash.com/photo-1574269909862-7e1d70bb8078?w=600&auto=format&fit=crop&q=80',
      ],
      colors: ['#64748B', '#0F172A'],
      sizes: ['27L', '32L Inverter'],
      description:
          'Cyclonic Inverter technology provides continuous, non-pulsing heating for even defrosting, roasting, and baking. Stainless steel interior with 20 auto-cook menus.',
      tags: ['special', 'appliances'],
    ),
  ];

  /// Checks if an API product is a student test junk item
  static bool isGarbageProduct(Product p) {
    final title = p.title.trim().toLowerCase();
    if (title.isEmpty || title.length < 3) return true;

    const junkTitles = [
      'title', 'test', 'safws', 'sdg', 'asdasd', 'fgjh', 'sagfdgsh',
      'demo', 'new category', 'apply', 'test product', 'dummy', 'asdf',
    ];

    for (final junk in junkTitles) {
      if (title == junk || title.startsWith('$junk ') || title.endsWith(' $junk')) {
        return true;
      }
    }

    if (p.photos.isEmpty && p.description.trim().length < 5) return true;

    return false;
  }

  static List<Product> getByCategory(String? categoryIdOrTitle) {
    if (categoryIdOrTitle == null || categoryIdOrTitle.isEmpty) return products;
    final query = categoryIdOrTitle.toLowerCase().trim();

    final matched = products.where((p) {
      final cId = p.categoryId.toLowerCase();
      final cTitle = p.categoryTitle.toLowerCase();
      return cId == query ||
          cTitle == query ||
          query.contains(cTitle) ||
          cTitle.contains(query) ||
          query.contains(cId.replaceAll('cat_', ''));
    }).toList();

    return matched.isNotEmpty ? matched : products;
  }

  static Product? getById(String id) {
    try {
      return products.firstWhere((p) => p.id == id);
    } catch (_) {
      return null;
    }
  }

  static List<Product> getByTag(String tag) {
    final t = tag.toLowerCase().trim();
    return products.where((p) => p.tags.contains(t)).toList();
  }

  static List<Product> search(String query) {
    final q = query.toLowerCase().trim();
    if (q.isEmpty) return products;
    return products.where((p) {
      return p.title.toLowerCase().contains(q) ||
          p.categoryTitle.toLowerCase().contains(q) ||
          p.brand.toLowerCase().contains(q) ||
          p.description.toLowerCase().contains(q);
    }).toList();
  }

  /// Sanitizes API products to remove test garbage and assign accurate category/info
  static Product sanitize(Product p) {
    final exact = getById(p.id);
    if (exact != null) return exact;

    final lower = p.title.toLowerCase();

    // Match Mac mini
    if (lower.contains('mac') && lower.contains('mini')) {
      return p.copyWith(
        title: 'Apple Mac Mini M4',
        brand: 'Apple',
        categoryTitle: 'Electronics',
        categoryId: 'cat_electronics',
        currentPrice: p.currentPrice > 0 ? p.currentPrice : 699.0,
        regularPrice: p.regularPrice > 0 ? p.regularPrice : 799.0,
        photos: p.photos.isNotEmpty
            ? p.photos
            : [
                'https://mcsolution.com.bd/wp-content/uploads/2024/10/mac-mini-m4-2024-price-in-Bangladesh-MC-Solution-BD-2.webp',
                'https://images.unsplash.com/photo-1517059224940-d4af9eec41b7?w=600&auto=format&fit=crop&q=80',
              ],
        description:
            'The all-new Mac mini powered by the M4 chip delivers extraordinary performance in an impossibly small 5x5 inch frame. Featuring front-facing USB-C ports, Thunderbolt 4 connectivity, and built for Apple Intelligence.',
        colors: const ['#D1D5DB', '#374151'],
        sizes: const ['256GB', '512GB', '1TB'],
      );
    }

    // Match Bengali Books
    if (p.title.contains('অ্যালগরিদম')) {
      return p.copyWith(
        title: 'সহজ ভাষায় অ্যালগরিদম',
        brand: 'Rokomari',
        categoryTitle: 'Books',
        categoryId: 'cat_books',
        currentPrice: p.currentPrice > 0 ? p.currentPrice : 12.0,
        regularPrice: p.regularPrice > 0 ? p.regularPrice : 18.0,
        photos: p.photos.isNotEmpty
            ? p.photos
            : [
                'https://ds.rokomari.store/rokomari110/ProductNew20190903/260X372/Sohoj_Bhashay_Algorithm-Ihsanul_Islam-ab6e3-227461.jpg',
              ],
        colors: const ['#2563EB'],
        sizes: const ['Paperback'],
        description:
            'কম্পিউটার বিজ্ঞানের প্রাণ হলো অ্যালগরিদম। বাংলা ভাষায় অত্যন্ত সহজ ও সাবলীল উদাহরণসহ কমপ্লেক্সিটি, সর্টিং, সার্চিং এবং গ্রাফ অ্যালগরিদম শেখার সেরা বই।',
      );
    }

    if (p.title.contains('ব্যাটারি')) {
      return p.copyWith(
        title: 'রিচার্জ ইয়োর ডাউন ব্যাটারি',
        brand: 'Wafilife',
        categoryTitle: 'Books',
        categoryId: 'cat_books',
        currentPrice: p.currentPrice > 0 ? p.currentPrice : 10.0,
        regularPrice: p.regularPrice > 0 ? p.regularPrice : 15.0,
        photos: p.photos.isNotEmpty
            ? p.photos
            : [
                'https://wafilife-media.wafilife.com/uploads/2020/11/%E0%A6%B0%E0%A6%BF%E0%A6%9A%E0%A6%BE%E0%A6%B0%E0%A7%8D%E0%A6%9C-%E0%A6%87%E0%A7%9F%E0%A7%8B%E0%A6%B0-%E0%A6%A1%E0%A6%BE%E0%A6%89%E0%A6%A8-%E0%A6%AC%E0%A7%8D%E0%A6%AF%E0%A6%BE%E0%A6%9F%E0%A6%BE%E0%A6%B0%E0%A6%BF-250x386.jpg',
              ],
        colors: const ['#DC2626'],
        sizes: const ['Paperback', 'Hardcover'],
        description:
            'ঝিমিয়ে পড়া আত্মবিশ্বাসকে চাঙ্গা করার অসাধারণ অনুপ্রেরণামূলক বই। লেখক জীবনের কঠিন মুহূর্তে ইতিবাচক চিন্তা ও শক্তি ফিরে পাওয়ার বাস্তবসম্মত সমাধান তুলে ধরেছেন।',
      );
    }

    if (p.title.contains('জাভা') || p.title.contains('প্রোগ্রামিং')) {
      return p.copyWith(
        title: 'জাভা প্রোগ্রামিং',
        brand: 'Wafilife',
        categoryTitle: 'Books',
        categoryId: 'cat_books',
        currentPrice: p.currentPrice > 0 ? p.currentPrice : 15.0,
        regularPrice: p.regularPrice > 0 ? p.regularPrice : 22.0,
        photos: p.photos.isNotEmpty
            ? p.photos
            : [
                'https://wafilife-media.wafilife.com/uploads/2020/01/java-250x341.png',
              ],
        colors: const ['#EA580C'],
        sizes: const ['Paperback'],
        description:
            'জাভা ল্যাঙ্গুয়েজের অবজেক্ট ওরিয়েন্টেড প্রোগ্রামিং (OOP), মাল্টিথ্রেডিং, কালেকশন ফ্রেমওয়ার্ক এবং সফটওয়্যার ডেভেলপমেন্টের পূর্ণাঙ্গ গাইড।',
      );
    }

    // Match Phone / Electronics
    if (lower.contains('phone') || lower.contains('tus') || lower.contains('oppo')) {
      return p.copyWith(
        title: p.title.startsWith('TUS') ? 'Smart Touch 5G Smartphone' : p.title,
        brand: 'Oppo',
        categoryTitle: 'Electronics',
        categoryId: 'cat_electronics',
        colors: const ['#1F2937', '#2563EB', '#D1D5DB'],
        sizes: const ['128GB', '256GB'],
        description:
            'High-performance 5G smartphone featuring vivid AMOLED 120Hz display, multi-lens camera system, and ultra-fast charging.',
      );
    }

    // Match Shoes
    if (lower.contains('shoe') || lower.contains('deal') || lower.contains('sneaker')) {
      return p.copyWith(
        categoryTitle: 'Fashion',
        categoryId: 'cat_fashion',
        photos: p.photos.isNotEmpty ? p.photos : ['assets/images/shoe.png'],
        colors: p.colors.isNotEmpty ? p.colors : ['#1E88E5', '#E53935', '#757575', '#212121'],
        sizes: p.sizes.isNotEmpty ? p.sizes : ['40', '41', '42', '43', '44'],
      );
    }

    return p;
  }
}
