export const DATA_GLOBAL: Record<string, any> = {
  restaurantes: {
    titulo: "Restaurantes",
    tiendas: [
      { id: "lc", nombre: "Little Caesars", rating: "4.5", tiempo: "15-25", img: "https://raw.githubusercontent.com/ARROYOCARLOS0478/imagenes/refs/heads/main/little-ca.PNG" },
      { id: "ph", nombre: "Pizza Hut", rating: "4.2", tiempo: "25-35", img: "https://raw.githubusercontent.com/ARROYOCARLOS0478/imagenes/refs/heads/main/pizzahut.jfif" },
      { id: "kf", nombre: "KFC", rating: "4.3", tiempo: "20-30", img: "https://raw.githubusercontent.com/ARROYOCARLOS0478/imagenes/refs/heads/main/kfc.jpg" },
      { id: "dq", nombre: "Dairy Queen", rating: "4.8", tiempo: "10-20", img: "https://raw.githubusercontent.com/ARROYOCARLOS0478/imagenes/refs/heads/main/dairyqueen.jfif" },
      { id: "bk", nombre: "Burger King", rating: "4.4", tiempo: "15-25", img: "https://raw.githubusercontent.com/ARROYOCARLOS0478/imagenes/refs/heads/main/burguerking.jfif" },
      { id: "sw", nombre: "Subway", rating: "4.6", tiempo: "10-20", img: "https://raw.githubusercontent.com/ARROYOCARLOS0478/imagenes/refs/heads/main/subway.jfif" },
      { id: "mc", nombre: "McDonald's", rating: "4.5", tiempo: "15-20", img: "https://raw.githubusercontent.com/ARROYOCARLOS0478/imagenes/refs/heads/main/macdonals.jfif" },
    ]
  },
  supermercado: {
    titulo: "Supermercado",
    tiendas: [
      { id: "smart", nombre: "S-Mart", rating: "4.9", tiempo: "30-45", img: "https://images.unsplash.com/photo-1534723452862-4c874018d66d?w=500" },
      { id: "walmart", nombre: "Walmart", rating: "4.7", tiempo: "25-40", img: "https://images.unsplash.com/photo-1542838132-92c53300491e?w=500" },
      { id: "costco", nombre: "Costco", rating: "4.9", tiempo: "45-60", img: "https://raw.githubusercontent.com/ARROYOCARLOS0478/imagenes/refs/heads/main/costco.jfif" },
      { id: "ley", nombre: "Casa Ley", rating: "4.4", tiempo: "35-55", img: "https://raw.githubusercontent.com/ARROYOCARLOS0478/imagenes/refs/heads/main/casaley.jfif" },
      { id: "soriana", nombre: "Soriana", rating: "4.5", tiempo: "30-50", img: "https://images.unsplash.com/photo-1578916171728-46686eac8d58?w=500" },
      { id: "sams", nombre: "Sam's Club", rating: "4.8", tiempo: "40-55", img: "https://images.unsplash.com/photo-1583258292688-d0213dc5a3a8?w=500" },
      { id: "alsuper", nombre: "Alsuper", rating: "4.7", tiempo: "20-35", img: "https://raw.githubusercontent.com/ARROYOCARLOS0478/imagenes/refs/heads/main/alsuper.jfif" },
    ]
  },
  farmacia: {
    titulo: "Farmacia",
    tiendas: [
      { id: "fsimi", nombre: "F. Similares", rating: "4.8", tiempo: "15-25", img: "https://images.unsplash.com/photo-1586015555751-63bb77f4322a?w=500" },
      { id: "fguada", nombre: "F. Guadalajara", rating: "4.7", tiempo: "20-30", img: "https://images.unsplash.com/photo-1576602976047-174e57a47881?w=500" },
      { id: "fbenav", nombre: "F. Benavides", rating: "4.6", tiempo: "15-25", img: "https://raw.githubusercontent.com/ARROYOCARLOS0478/imagenes/refs/heads/main/Fbenavides.jfif" },
      { id: "fahorro", nombre: "F. del Ahorro", rating: "4.5", tiempo: "20-35", img: "https://raw.githubusercontent.com/ARROYOCARLOS0478/imagenes/refs/heads/main/FAhorro.jfif" },
    ]
  },
  licor: {
    titulo: "Licores",
    tiendas: [
      { id: "mod", nombre: "Modelorama", rating: "4.8", tiempo: "10-20", img: "https://raw.githubusercontent.com/ARROYOCARLOS0478/imagenes/refs/heads/main/modelorama.jfif" },
      { id: "vin", nombre: "Vinoteca", rating: "4.9", tiempo: "20-30", img: "https://images.unsplash.com/photo-1510812431401-41d2bd2722f3?w=500" },
      { id: "beer", nombre: "The Beer Box", rating: "4.7", tiempo: "20-30", img: "https://raw.githubusercontent.com/ARROYOCARLOS0478/imagenes/refs/heads/main/beerbox.jfif" },
    ]
  },
  express: {
    titulo: "Express",
    tiendas: [
      { id: "dr", nombre: "Del Río", rating: "4.7", tiempo: "10-15", img: "https://raw.githubusercontent.com/ARROYOCARLOS0478/imagenes/refs/heads/main/delrio.jfif" },
      { id: "ox", nombre: "OXXO", rating: "4.5", tiempo: "10-15", img: "https://raw.githubusercontent.com/ARROYOCARLOS0478/imagenes/refs/heads/main/oxxo.jfif" },
      { id: "7e", nombre: "7-Eleven", rating: "4.6", tiempo: "10-20", img: "https://raw.githubusercontent.com/ARROYOCARLOS0478/imagenes/refs/heads/main/7eleven.jfif" },
    ]
  },
  tiendas: {
    titulo: "Tiendas Departamentales",
    tiendas: [
      { id: "liverpool", nombre: "Liverpool", rating: "4.9", tiempo: "60-90", img: "https://raw.githubusercontent.com/ARROYOCARLOS0478/imagenes/refs/heads/main/liverpool.jfif" },
      { id: "coppel", nombre: "Coppel", rating: "4.6", tiempo: "45-60", img: "https://images.unsplash.com/photo-1441986300917-64674bd600d8?w=500" },
      { id: "sears", nombre: "Sears", rating: "4.5", tiempo: "50-70", img: "https://raw.githubusercontent.com/ARROYOCARLOS0478/imagenes/refs/heads/main/sears.jfif" },
    ]
  }
};

export const PRODUCTOS_DATA: Record<string, any[]> = {
  // --- RESTAURANTES ---
  lc: [
    { id: "lc1", nombre: "Pizza Pepperoni", precio: 149, info: "La clásica pizza Hot-N-Ready.", img: "https://images.unsplash.com/photo-1628840042765-356cda07504e?w=500" },
    { id: "lc2", nombre: "Crazy Bread", precio: 69, info: "8 palitroques de pan con mantequilla.", img: "https://raw.githubusercontent.com/ARROYOCARLOS0478/imagenes/refs/heads/main/crazybread.jfif" },
    { id: "lc3", nombre: "Pizza 3 Meat", precio: 189, info: "Pepperoni, salchicha y tocino.", img: "https://images.unsplash.com/photo-1541745537411-b8046dc6d66c?w=500" },
    { id: "lc4", nombre: "Alitas Buffalo", precio: 119, info: "Alitas bañadas en salsa picante.", img: "https://images.unsplash.com/photo-1527477396000-e27163b481c2?w=500" }
  ],
  ph: [
    { id: "ph1", nombre: "Pizza Suprema", precio: 249, info: "Pepperoni, carne, pimientos y cebolla.", img: "https://images.unsplash.com/photo-1513104890138-7c749659a591?w=500" },
    { id: "ph2", nombre: "Hut Wings BBQ", precio: 139, info: "Alitas con salsa BBQ dulce.", img: "https://raw.githubusercontent.com/ARROYOCARLOS0478/imagenes/refs/heads/main/hutwings.jfif" },
    { id: "ph3", nombre: "Pizzeta Ind.", precio: 89, info: "Tamaño personal de 2 ingredientes.", img: "https://images.unsplash.com/photo-1565299624946-b28f40a0ae38?w=500" },
    { id: "ph4", nombre: "Palitos Queso", precio: 75, info: "Pan con queso y salsa marinara.", img: "https://raw.githubusercontent.com/ARROYOCARLOS0478/imagenes/refs/heads/main/palqueso.jfif" }
  ],
  kf: [
    { id: "kf1", nombre: "Cubeta 8 Pzs", precio: 259, info: "Pollo frito receta original.", img: "https://images.unsplash.com/photo-1513639776629-7b61b0ac49cb?w=500" },
    { id: "kf2", nombre: "Ke-Tira Box", precio: 129, info: "Tiras, puré, ensalada y biscuit.", img: "https://images.unsplash.com/photo-1626082927389-6cd097cdc6ec?w=500" },
    { id: "kf3", nombre: "Big Box Burg.", precio: 155, info: "Hamburguesa de pollo y complementos.", img: "https://images.unsplash.com/photo-1610614819513-58e34989848b?w=500" },
    { id: "kf4", nombre: "Puré Fam.", precio: 65, info: "Puré cremoso con gravy clásico.", img: "https://raw.githubusercontent.com/ARROYOCARLOS0478/imagenes/refs/heads/main/purefam.jfif" }
  ],
  sw: [
    { id: "sw1", nombre: "Subway Club", precio: 125, info: "Pavo, jamón y roast beef.", img: "https://raw.githubusercontent.com/ARROYOCARLOS0478/imagenes/refs/heads/main/subClub.jfif" },
    { id: "sw2", nombre: "Italian B.M.T.", precio: 115, info: "Salami, pepperoni y jamón.", img: "https://images.unsplash.com/photo-1559466273-d95e72debaf8?w=500" },
    { id: "sw3", nombre: "Atún Sub", precio: 105, info: "Atún con mayonesa y vegetales.", img: "https://raw.githubusercontent.com/ARROYOCARLOS0478/imagenes/refs/heads/main/subAtun.jfif" },
    { id: "sw4", nombre: "Galleta Chispas", precio: 25, info: "Recién horneada.", img: "https://images.unsplash.com/photo-1499636136210-6f4ee915583e?w=500" }
  ],
  mc: [
    { id: "mc1", nombre: "Big Mac", precio: 99, info: "El clásico de dos carnes.", img: "https://images.unsplash.com/photo-1571091718767-18b5b1457add?w=500" },
    { id: "mc2", nombre: "McNuggets 10p", precio: 85, info: "Pollo crujiente con salsa.", img: "https://raw.githubusercontent.com/ARROYOCARLOS0478/imagenes/refs/heads/main/magnuggets.jfif" },
    { id: "mc3", nombre: "Papas Grandes", precio: 45, info: "Las papas más famosas.", img: "https://raw.githubusercontent.com/ARROYOCARLOS0478/imagenes/refs/heads/main/magnuggets.jfif" },
    { id: "mc4", nombre: "McFlurry Oreo", precio: 55, info: "Helado con galleta Oreo.", img: "https://images.unsplash.com/photo-1572490122747-3968b75cc699?w=500" }
  ],
  bk: [
    { id: "bk1", nombre: "Whopper", precio: 105, info: "A la parrilla sabe mejor.", img: "https://images.unsplash.com/photo-1571091718767-18b5b1457add?w=500" },
    { id: "bk2", nombre: "King de Pollo", precio: 89, info: "Pechuga larga empanizada.", img: "https://images.unsplash.com/photo-1610614819513-58e34989848b?w=500" },
    { id: "bk3", nombre: "Aros Cebolla", precio: 45, info: "Crujientes y dorados.", img: "https://raw.githubusercontent.com/ARROYOCARLOS0478/imagenes/refs/heads/main/aroscebolla.jfif" },
    { id: "bk4", nombre: "Hershey Pie", precio: 39, info: "Pay de chocolate helado.", img: "https://images.unsplash.com/photo-1551024601-bec78aea704b?w=500" }
  ],
  dq: [
    { id: "dq1", nombre: "Blizzard Oreo", precio: 75, info: "No se cae si lo volteas.", img: "https://images.unsplash.com/photo-1572490122747-3968b75cc699?w=500" },
    { id: "dq2", nombre: "Dilly Bar", precio: 35, info: "Vainilla con chocolate.", img: "https://raw.githubusercontent.com/ARROYOCARLOS0478/imagenes/refs/heads/main/dillybar.jfif" },
    { id: "dq3", nombre: "Banana Split", precio: 95, info: "El postre más completo.", img: "https://images.unsplash.com/photo-1588195538326-c5b1e9f80a1b?w=500" },
    { id: "dq4", nombre: "dq Sandwich", precio: 25, info: "Helado entre galletas chocolate.", img: "https://raw.githubusercontent.com/ARROYOCARLOS0478/imagenes/refs/heads/main/sandwichDQ.jfif" }
  ],

  // --- SUPERMERCADOS ---
  walmart: [
    { id: "wa1", nombre: "Aceite 1L", precio: 45, info: "Refinado vegetal.", img: "https://images.unsplash.com/photo-1474979266404-7eaacbad92c5?w=500" },
    { id: "wa2", nombre: "Arroz 1kg", precio: 28, info: "Grano largo.", img: "https://images.unsplash.com/photo-1586201375761-83865001e31c?w=500" },
    { id: "wa3", nombre: "Papel Hig. 12", precio: 110, info: "Hojas dobles.", img: "https://images.unsplash.com/photo-1584622781564-1d9876a13d00?w=500" },
    { id: "wa4", nombre: "Leche 1L", precio: 26, info: "Entera Great Value.", img: "https://images.unsplash.com/photo-1563636619-e910f01859ec?w=500" }
  ],
  smart: [
    { id: "sm1", nombre: "Pollo kg", precio: 120, info: "Pechuga sin hueso.", img: "https://images.unsplash.com/photo-1604503468506-a8da13d82791?w=500" },
    { id: "sm2", nombre: "Huevo 30p", precio: 85, info: "Blanco seleccionado.", img: "https://images.unsplash.com/photo-1587486918502-319c9e8dcbc6?w=500" },
    { id: "sm3", nombre: "Aguacate kg", precio: 68, info: "Hass en su punto.", img: "https://images.unsplash.com/photo-1523049673857-eb18f1d7b578?w=500" },
    { id: "sm4", nombre: "Tortillas kg", precio: 22, info: "Maíz recién hechas.", img: "https://images.unsplash.com/photo-1552526849-0097f7663471?w=500" }
  ],
  costco: [
    { id: "co1", nombre: "Pizza Gigante", precio: 199, info: "La famosa pizza de Costco.", img: "https://images.unsplash.com/photo-1513104890138-7c749659a591?w=500" },
    { id: "co2", nombre: "Hot Dog Combo", precio: 35, info: "Salchicha de res y refresco.", img: "https://images.unsplash.com/photo-1541288097308-7b8e3f58c4c6?w=500" },
    { id: "co3", nombre: "Pollo Rost.", precio: 115, info: "El favorito de todos.", img: "https://images.unsplash.com/photo-1587593817645-4250a84c25b8?w=500" },
    { id: "co4", nombre: "Pastel Choco", precio: 280, info: "Tuxedo cake premium.", img: "https://images.unsplash.com/photo-1578985545062-69928b1d9587?w=500" }
  ],
  soriana: [
    { id: "so1", nombre: "Frijol 1kg", precio: 34, info: "Pinto de primera.", img: "https://images.unsplash.com/photo-1551462147-37885acc3c41?w=500" },
    { id: "so2", nombre: "Azúcar 1kg", precio: 29, info: "Estándar morena.", img: "https://images.unsplash.com/photo-1622484210921-29471343734a?w=500" },
    { id: "so3", nombre: "Pasta 200g", precio: 12, info: "Fideo o spaguetti.", img: "https://images.unsplash.com/photo-1551462147-ff29053bfc14?w=500" },
    { id: "so4", nombre: "Sal de Mar", precio: 18, info: "Bolsa de 500g.", img: "https://images.unsplash.com/photo-1615485240314-5d5137286392?w=500" }
  ],
  ley: [
    { id: "le1", nombre: "Manzana kg", precio: 45, info: "Gala roja fresca.", img: "https://images.unsplash.com/photo-1567306226416-28f0efdc88ce?w=500" },
    { id: "le2", nombre: "Plátano kg", precio: 24, info: "Tabasco maduro.", img: "https://images.unsplash.com/photo-1571771894821-ad9902410947?w=500" },
    { id: "le3", nombre: "Limón kg", precio: 38, info: "Con semilla colima.", img: "https://images.unsplash.com/photo-1590502593457-4c3290630b95?w=500" },
    { id: "le4", nombre: "Tomate kg", precio: 28, info: "Saladette firme.", img: "https://images.unsplash.com/photo-1518977676601-b53f02ac6d31?w=500" }
  ],
  sams: [
    { id: "sa1", nombre: "Papitas Fam.", precio: 145, info: "Bolsa gigante 500g.", img: "https://images.unsplash.com/photo-1566478989037-eec170784d0b?w=500" },
    { id: "sa2", nombre: "Detergente 10L", precio: 299, info: "Líquido Member's Mark.", img: "https://images.unsplash.com/photo-1584622650111-993a426fbf0a?w=500" },
    { id: "sa3", nombre: "Pan Dulce 12p", precio: 95, info: "Variedad horneada.", img: "https://images.unsplash.com/photo-1509440159596-0249088772ff?w=500" },
    { id: "sa4", nombre: "Agua 40p", precio: 85, info: "Paquete botellas 500ml.", img: "https://images.unsplash.com/photo-1548839140-29a74d77cb4e?w=500" }
  ],
  alsuper: [
    { id: "al1", nombre: "Carne Asada", precio: 240, info: "Diezmillo para asar.", img: "https://images.unsplash.com/photo-1558030006-450675393462?w=500" },
    { id: "al2", nombre: "Queso Menona", precio: 160, info: "Kilo de queso real.", img: "https://images.unsplash.com/photo-1485955900006-10f4d324d411?w=500" },
    { id: "al3", nombre: "Clericot L", precio: 95, info: "Preparado de fruta.", img: "https://images.unsplash.com/photo-1541533693007-fca82739457a?w=500" },
    { id: "al4", nombre: "Pan Blanco", precio: 45, info: "Barra artesanal.", img: "https://images.unsplash.com/photo-1509440159596-0249088772ff?w=500" }
  ],

  // --- FARMACIAS ---
  fsimi: [
    { id: "fs1", nombre: "Paracetamol", precio: 18, info: "Dolor y fiebre.", img: "https://images.unsplash.com/photo-1584308666744-24d5c474f2ae?w=500" },
    { id: "fs2", nombre: "Vitamina C", precio: 130, info: "Refuerza defensas.", img: "https://raw.githubusercontent.com/ARROYOCARLOS0478/imagenes/refs/heads/main/vitaminaC.jfif" },
    { id: "fs3", nombre: "Suero 500ml", precio: 25, info: "Electrolitos fresa.", img: "https://images.unsplash.com/photo-1628771065518-0d82f1938462?w=500" },
    { id: "fs4", nombre: "Omeprazol", precio: 45, info: "Antiácido 20mg.", img: "https://raw.githubusercontent.com/ARROYOCARLOS0478/imagenes/refs/heads/main/omeprazol.jfif" }
  ],
  fguada: [
    { id: "fg1", nombre: "Pañales Et3", precio: 245, info: "Paquete 40 piezas.", img: "https://raw.githubusercontent.com/ARROYOCARLOS0478/imagenes/refs/heads/main/pa%C3%B1ales.jfif" },
    { id: "fg2", nombre: "Shampoo R.", precio: 85, info: "Cuidado capilar 400ml.", img: "https://images.unsplash.com/photo-1526947425960-945c6e72858f?w=500" },
    { id: "fg3", nombre: "Jabón Baño", precio: 22, info: "Barra humectante.", img: "https://images.unsplash.com/photo-1600857544200-b2f666a9a2ec?w=500" },
    { id: "fg4", nombre: "Agua Galón", precio: 32, info: "Purificada 5L.", img: "https://raw.githubusercontent.com/ARROYOCARLOS0478/imagenes/refs/heads/main/aguagalon.jfif" }
  ],
  fbenav: [
    { id: "fb1", nombre: "Bloqueador", precio: 380, info: "FPS 50+ toque seco.", img: "https://images.unsplash.com/photo-1556228720-195a672e8a03?w=500" },
    { id: "fb2", nombre: "Cepillo D.", precio: 65, info: "Cerdas suaves.", img: "https://raw.githubusercontent.com/ARROYOCARLOS0478/imagenes/refs/heads/main/cepillodental.jfif" },
    { id: "fb3", nombre: "Gel Cabello", precio: 45, info: "Fijación extrema.", img: "https://raw.githubusercontent.com/ARROYOCARLOS0478/imagenes/refs/heads/main/gel.jfif" },
    { id: "fb4", nombre: "Curitas 10p", precio: 28, info: "Resistentes al agua.", img: "https://images.unsplash.com/photo-1563453392212-326f5e854473?w=500" }
  ],
  fahorro: [
    { id: "fa1", nombre: "Loratadina", precio: 35, info: "Antihistamínico.", img: "https://images.unsplash.com/photo-1584308666744-24d5c474f2ae?w=500" },
    { id: "fa2", nombre: "Gel Antibac.", precio: 38, info: "99% protección.", img: "https://images.unsplash.com/photo-1584622781564-1d9876a13d00?w=500" },
    { id: "fa3", nombre: "Termómetro", precio: 120, info: "Digital lectura rápida.", img: "https://images.unsplash.com/photo-1584032792291-b92e7011d607?w=500" },
    { id: "fa4", nombre: "Gasas 10p", precio: 25, info: "Estériles 10x10.", img: "https://images.unsplash.com/photo-1584032792291-b92e7011d607?w=500" }
  ],

  // --- LICORES ---
  mod: [
    { id: "mo1", nombre: "Corona 6pk", precio: 118, info: "Botella 355ml.", img: "https://images.unsplash.com/photo-1618885472179-5e474019f2a9?w=500" },
    { id: "mo2", nombre: "Modelo Latón", precio: 135, info: "6 latas pilsner.", img: "https://images.unsplash.com/photo-1550348245-4b553a893690?w=500" },
    { id: "mo3", nombre: "Victoria 12p", precio: 195, info: "Cerveza tipo vienna.", img: "https://images.unsplash.com/photo-1597075095353-066748433440?w=500" },
    { id: "mo4", nombre: "Hielo 5kg", precio: 40, info: "Purificado cristalino.", img: "https://images.unsplash.com/photo-1551717743-49959800b1f6?w=500" }
  ],
  vin: [
    { id: "vi1", nombre: "Vino Tinto", precio: 450, info: "Cabernet Sauvignon.", img: "https://images.unsplash.com/photo-1510812431401-41d2bd2722f3?w=500" },
    { id: "vi2", nombre: "Tequila Añejo", precio: 850, info: "100% Agave azul.", img: "https://images.unsplash.com/photo-1516750484197-6b28d10c91ea?w=500" },
    { id: "vi3", nombre: "Whisky 12A", precio: 950, info: "Escocés de malta.", img: "https://images.unsplash.com/photo-1527281400828-ac737aef5ad4?w=500" },
    { id: "vi4", nombre: "Ginebra 750ml", precio: 680, info: "Notas de enebro.", img: "https://images.unsplash.com/photo-1551538827-9c037cb4f32a?w=500" }
  ],
  beer: [
    { id: "be1", nombre: "IPA Artesanal", precio: 85, info: "Notas cítricas.", img: "https://images.unsplash.com/photo-1535958636474-b021ee887b13?w=500" },
    { id: "be2", nombre: "Stout Choc.", precio: 95, info: "Notas café cacao.", img: "https://images.unsplash.com/photo-1584225064785-c72a9593c2a7?w=500" },
    { id: "be3", nombre: "Sampler 4p", precio: 280, info: "Mix de barril.", img: "https://images.unsplash.com/photo-1571767454098-246b9198c83e?w=500" },
    { id: "be4", nombre: "Lager Suave", precio: 65, info: "Muy refrescante.", img: "https://images.unsplash.com/photo-1567696153598-f3127394b8c0?w=500" }
  ],

  // --- EXPRESS ---
  dr: [
    { id: "dr1", nombre: "Burrito Chil.", precio: 22, info: "Chile chilaca queso.", img: "https://images.unsplash.com/photo-1584031036380-3fb6f2d51880?w=500" },
    { id: "dr2", nombre: "Café Grande", precio: 28, info: "Mezcla exclusiva.", img: "https://images.unsplash.com/photo-1544787210-2211d44b565a?w=500" },
    { id: "dr3", nombre: "Sándwich Mixto", precio: 45, info: "Jamón y queso.", img: "https://images.unsplash.com/photo-1539252554452-da0967485748?w=500" },
    { id: "dr4", nombre: "Coca Cola 600", precio: 18, info: "Bien helada.", img: "https://images.unsplash.com/photo-1622483767028-3f66f32aef97?w=500" }
  ],
  ox: [
    { id: "ox1", nombre: "Vikingo Reg.", precio: 25, info: "Hot dog clásico.", img: "https://images.unsplash.com/photo-1541288097308-7b8e3f58c4c6?w=500" },
    { id: "ox2", nombre: "Andatti V.", precio: 32, info: "Capuchino caliente.", img: "https://images.unsplash.com/photo-1544787210-2211d44b565a?w=500" },
    { id: "ox3", nombre: "Lonchibón", precio: 42, info: "Sándwich de pavo.", img: "https://images.unsplash.com/photo-1539252554452-da0967485748?w=500" },
    { id: "ox4", nombre: "Chips Fuego", precio: 18, info: "Sabor limón chile.", img: "https://images.unsplash.com/photo-1566478989037-eec170784d0b?w=500" }
  ],
  "7e": [
    { id: "7e1", nombre: "Big Bite", precio: 25, info: "Hot dog jumbo.", img: "https://images.unsplash.com/photo-1541288097308-7b8e3f58c4c6?w=500" },
    { id: "7e2", nombre: "Slurpee L", precio: 35, info: "Bebida congelada.", img: "https://images.unsplash.com/photo-1470337458703-46ad1756a187?w=500" },
    { id: "7e3", nombre: "Dona Glace.", precio: 15, info: "Recién traída.", img: "https://images.unsplash.com/photo-1527904324834-3bda86da67f1?w=500" },
    { id: "7e4", nombre: "Pizzegue", precio: 45, info: "Rebanada caliente.", img: "https://images.unsplash.com/photo-1513104890138-7c749659a591?w=500" }
  ],

  // --- DEPARTAMENTALES ---
  liverpool: [
    { id: "li1", nombre: "Perfume Sauv.", precio: 2400, info: "Dior 100ml.", img: "https://images.unsplash.com/photo-1541643600914-78b084683601?w=500" },
    { id: "li2", nombre: "Nike Air Max", precio: 1950, info: "Calzado deportivo.", img: "https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=500" },
    { id: "li3", nombre: "Bolsa MK", precio: 3800, info: "Piel genuina.", img: "https://images.unsplash.com/photo-1584917865442-de89df76afd3?w=500" },
    { id: "li4", nombre: "Cartera Tommy", precio: 850, info: "Piel café.", img: "https://images.unsplash.com/photo-1627123424574-724758594e93?w=500" }
  ],
  coppel: [
    { id: "cp1", nombre: "Samsung A54", precio: 5499, info: "128GB 5G.", img: "https://images.unsplash.com/photo-1610945265064-0e34e5519bbf?w=500" },
    { id: "cp2", nombre: "Colchón Ind.", precio: 3200, info: "Ortopédico.", img: "https://images.unsplash.com/photo-1505691938895-1758d7eaa511?w=500" },
    { id: "cp3", nombre: "Bicicleta R26", precio: 4100, info: "Montaña 21 vel.", img: "https://images.unsplash.com/photo-1485965120184-e220f721d03e?w=500" },
    { id: "cp4", nombre: "Tenis Reebok", precio: 1250, info: "Blancos clásicos.", img: "https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=500" }
  ],
  sears: [
    { id: "sr1", nombre: "Reloj Bulova", precio: 4500, info: "Cronógrafo acero.", img: "https://images.unsplash.com/photo-1522338242992-e1a54906a8da?w=500" },
    { id: "sr2", nombre: "Chamarra Piel", precio: 1899, info: "Slim fit negra.", img: "https://images.unsplash.com/photo-1521223890158-f9f7c3d5bab3?w=500" },
    { id: "sr3", nombre: "Cafetera Nesp.", precio: 2999, info: "Sistema cápsulas.", img: "https://images.unsplash.com/photo-1517914403423-285f3332a73a?w=500" },
    { id: "sr4", nombre: "Sartén T-Fal", precio: 650, info: "Antiadherente.", img: "https://images.unsplash.com/photo-1584946914183-a15f6133f11e?w=500" }
  ]
};

// YA NO HAY CÓDIGO AUTO-GENERADOR AQUÍ.