import { useState, useEffect } from "react";
import { 
  Search as SearchIcon, 
  Home as HomeIcon, 
  Tag as TagIcon, 
  Heart as HeartIcon, 
  User as UserIcon, 
  ChevronDown as ChevronIcon, 
  ShoppingCart, 
  Package, 
  Utensils, 
  Bike, 
  CheckCircle2, 
  X,
  Star,
  Clock,
  Zap
} from "lucide-react";
import { IPhoneFrame } from "../components/ui/IPhoneFrame";
import { useNavigate } from "react-router";
import { useCart } from "../../context/CartContext";

const categorias = [
  { id: 1, nombre: "Restaurantes", imagen: "https://raw.githubusercontent.com/ARROYOCARLOS0478/imagenes/refs/heads/main/hamburguesa.png", color: "#FCE4EC", size: "large", slug: "restaurantes" },
  { id: 2, nombre: "Supermercado", imagen: "https://raw.githubusercontent.com/ARROYOCARLOS0478/imagenes/refs/heads/main/carrito-super.png", color: "#E8F5E9", size: "large", slug: "supermercado" },
  { id: 3, nombre: "Farmacia", imagen: "https://raw.githubusercontent.com/ARROYOCARLOS0478/imagenes/refs/heads/main/botiquin.jfif", size: "small", slug: "farmacia" },
  { id: 4, nombre: "Tiendas", imagen: "https://images.unsplash.com/photo-1761333477936-56fbc7851c65?w=400", size: "small", slug: "tiendas" },
  { id: 5, nombre: "Express", imagen: "https://raw.githubusercontent.com/ARROYOCARLOS0478/imagenes/refs/heads/main/express.jfif", size: "small", slug: "express" },
  { id: 6, nombre: "Licor", imagen: "https://raw.githubusercontent.com/ARROYOCARLOS0478/imagenes/refs/heads/main/Licor.jfif", size: "small", slug: "licor" }
];

const BANNERS_PROMO = [
  { id: 1, titulo: "Envío Gratis", subtitulo: "En tu primer súper", negocio: "Walmart", color: "#0071CE", img: "https://images.unsplash.com/photo-1542838132-92c53300491e?w=600", slug: "supermercado" },
  { id: 2, titulo: "Bucket Familiar", subtitulo: "Precio Especial", negocio: "KFC", color: "#E4002B", img: "https://images.unsplash.com/photo-1513639776629-7b61b0ac49cb?w=600", slug: "restaurantes" },
  { id: 3, titulo: "Temporada de Regalos", subtitulo: "Hasta 15 meses sin intereses", negocio: "Liverpool", color: "#E10098", img: "https://images.unsplash.com/photo-1560243563-062abb001529?w=600", slug: "tiendas" },
];

const ofertasFlash = [
  { id: "lc", nombre: "Little Caesars", promo: "Pizza Hot-N-Ready -20%", rating: "4.5", tiempo: "15-25", img: "https://raw.githubusercontent.com/ARROYOCARLOS0478/imagenes/refs/heads/main/little-ca.PNG", slug: "restaurantes" },
  { id: "smart", nombre: "S-Mart", promo: "Frutas y Verduras -15%", rating: "4.9", tiempo: "30-45", img: "https://images.unsplash.com/photo-1534723452862-4c874018d66d?w=500", slug: "supermercado" },
  { id: "fsimi", nombre: "F. Similares", promo: "Lunes de Simi -25%", rating: "4.8", tiempo: "15-25", img: "https://images.unsplash.com/photo-1586015555751-63bb77f4322a?w=500", slug: "farmacia" },
  { id: "mod", nombre: "Modelorama", promo: "6-Pack Corona Promo", rating: "4.8", tiempo: "10-20", img: "https://raw.githubusercontent.com/ARROYOCARLOS0478/imagenes/refs/heads/main/modelorama.jfif", slug: "licor" },
  { id: "mc", nombre: "McDonald's", promo: "Big Mac Combo -30%", rating: "4.5", tiempo: "15-20", img: "https://raw.githubusercontent.com/ARROYOCARLOS0478/imagenes/refs/heads/main/macdonals.jfif", slug: "restaurantes" },
  { id: "ox", nombre: "OXXO", promo: "2 Vikingos por $45", rating: "4.5", tiempo: "10-15", img: "https://raw.githubusercontent.com/ARROYOCARLOS0478/imagenes/refs/heads/main/oxxo.jfif", slug: "express" },
  { id: "costco", nombre: "Costco", promo: "Envío Gratis hoy", rating: "4.9", tiempo: "45-60", img: "https://raw.githubusercontent.com/ARROYOCARLOS0478/imagenes/refs/heads/main/costco.jfif", slug: "supermercado" },
];

export default function HomeDashboard() {
  const [activeTab, setActiveTab] = useState("inicio");
  const navigate = useNavigate();
  const { totalProductos } = useCart();
  const hayItemsEnCarrito = totalProductos > 0;

  const [pedido, setPedido] = useState(() => {
    const pedidoGuardado = localStorage.getItem("flash_pedido_activo");
    return pedidoGuardado ? JSON.parse(pedidoGuardado) : null;
  });

  const etapasIconos = [
    { icon: <Package className="w-3 h-3" /> },
    { icon: <Utensils className="w-3 h-3" /> },
    { icon: <Bike className="w-3 h-3" /> },
    { icon: <CheckCircle2 className="w-3 h-3" /> }
  ];

  const etiquetas = ["Alistando tu pedido", "Preparando tu pedido", "Tu pedido va en camino", "Pedido entregado"];

  useEffect(() => {
    if (pedido && pedido.etapa < 3) {
      const interval = setInterval(() => {
        setPedido((prev: any) => {
          if (!prev) return null;
          let nuevoProgreso = (prev.progresoInterno || 0) + 1;
          let nuevaEtapa = prev.etapa;
          if (nuevoProgreso >= 100) {
            nuevaEtapa = Math.min(prev.etapa + 1, 3);
            nuevoProgreso = 0;
          }
          const actualizado = { ...prev, etapa: nuevaEtapa, progresoInterno: nuevoProgreso };
          localStorage.setItem("flash_pedido_activo", JSON.stringify(actualizado));
          return actualizado;
        });
      }, 50); 
      return () => clearInterval(interval);
    }
  }, [pedido?.etapa]);

  const anchoBarra = (pedido) ? (pedido.etapa * 33.33) + ((pedido.progresoInterno || 0) / 3) : 0;

  return (
    <IPhoneFrame>
      <div className="flex flex-col h-full bg-white overflow-hidden relative">
        
        {/* HEADER - ESTATICO ARRIBA */}
        <div className="bg-white px-6 pt-12 pb-4 z-20 border-b border-gray-50">
          <div className="flex justify-between items-center mb-4">
            <button onClick={() => navigate('/direcciones')} className="flex flex-col items-start group">
              <span className="font-black text-xl text-gray-900 leading-tight">Ciudad Juárez</span>
              <div className="flex items-center gap-1">
                <span className="text-[12px] text-gray-400 font-bold uppercase tracking-tight">Av. De la Raza 1234</span>
                <ChevronIcon className="w-4 h-4 text-[#FF441F]" />
              </div>
            </button>

            {hayItemsEnCarrito && (
              <button onClick={() => navigate('/canasta')} className="p-3 rounded-2xl bg-[#00BFA5] text-white shadow-xl shadow-teal-500/20 active:scale-90 transition-all relative">
                <ShoppingCart className="w-5 h-5" />
                <span className="absolute -top-1.5 -right-1.5 bg-[#FF441F] text-white text-[10px] font-black w-5 h-5 rounded-full flex items-center justify-center border-2 border-white">
                  {totalProductos}
                </span>
              </button>
            )}
          </div>

          <div className="relative">
            <SearchIcon className="absolute left-4 top-1/2 -translate-y-1/2 w-4 h-4 text-gray-400" />
            <input type="text" placeholder="¿Qué quisieras hoy?" className="w-full pl-11 pr-4 py-3 bg-gray-50 border border-gray-100 rounded-2xl text-sm font-medium focus:outline-none" />
          </div>
        </div>

        {/* CONTENIDO SCROLLABLE - Ocupa el centro y respeta los bordes */}
        <div className="flex-1 overflow-y-auto px-4 py-2 pb-32 scrollbar-hide">
          
          {/* TRACKING PEDIDO */}
          {pedido && (
            <div className="relative mb-6 animate-in slide-in-from-top duration-500 px-1 mt-2">
              <button onClick={() => navigate('/Deta-entre')} className="w-full p-5 bg-white border border-gray-100 shadow-xl shadow-gray-200/50 rounded-[2.5rem] text-left active:scale-[0.98] transition-transform">
                <div className="flex justify-between items-start mb-3">
                  <div>
                    <p className="text-[10px] font-black text-[#00BFA5] uppercase tracking-widest">Pedido en curso</p>
                    <h4 className="font-black text-gray-900 text-sm uppercase">{pedido.tienda || "Tu Pedido"}</h4>
                  </div>
                  {pedido.etapa === 3 && (
                    <X className="w-4 h-4 text-gray-300" onClick={(e) => { e.stopPropagation(); setPedido(null); localStorage.removeItem("flash_pedido_activo"); }} />
                  )}
                </div>
                <p className="text-[11px] font-black text-gray-800 mb-6 uppercase tracking-tighter">
                  {pedido.etapa === 3 ? `¡Pedido entregado! • ${pedido.timestamp || 'Hoy'}` : etiquetas[pedido.etapa]}
                </p>
                <div className="relative px-1 mb-2">
                  <div className="flex justify-between items-center relative z-10">
                    {etapasIconos.map((item, index) => (
                      <div key={index} className={`w-8 h-8 rounded-full flex items-center justify-center transition-all border-2 ${pedido.etapa >= index ? "bg-white border-[#00BFA5] text-[#00BFA5] shadow-sm" : "bg-gray-50 border-gray-100 text-gray-400"}`}>
                        {item.icon}
                      </div>
                    ))}
                  </div>
                  <div className="absolute top-4 left-4 right-4 h-1 bg-gray-100 -z-0 rounded-full overflow-hidden">
                    <div className="absolute top-0 left-0 h-full bg-[#00BFA5] transition-all duration-300 ease-linear" style={{ width: `${anchoBarra}%` }} />
                  </div>
                </div>
              </button>
            </div>
          )}

          {/* GRID CATEGORÍAS GRANDES */}
          <div className="grid grid-cols-2 gap-3 mb-6">
            {categorias.filter(c => c.size === "large").map((categoria) => (
              <button key={categoria.id} onClick={() => navigate(`/seccion/${categoria.slug}`)} className="flex flex-col items-center p-3 rounded-3xl shadow-sm active:scale-95 transition-transform" style={{ backgroundColor: categoria.color }}>
                <div className="w-full h-24 mb-2 rounded-2xl overflow-hidden shadow-inner">
                  <img src={categoria.imagen} className="w-full h-full object-cover" alt={categoria.nombre} />
                </div>
                <span className="font-black text-xs text-gray-800 uppercase tracking-tighter">{categoria.nombre}</span>
              </button>
            ))}
          </div>

          {/* GRID CATEGORÍAS PEQUEÑAS */}
          <div className="grid grid-cols-4 gap-2 mb-8">
            {categorias.filter(c => c.size === "small").map((categoria) => (
              <button key={categoria.id} onClick={() => navigate(`/seccion/${categoria.slug}`)} className="flex flex-col items-center gap-1.5 p-2.5 rounded-2xl bg-gray-100 active:scale-90 transition-transform">
                <div className="w-10 h-10 rounded-xl overflow-hidden">
                  <img src={categoria.imagen} className="w-full h-full object-cover" alt={categoria.nombre} />
                </div>
                <span className="text-[9px] text-gray-700 font-black text-center uppercase leading-none">{categoria.nombre}</span>
              </button>
            ))}
          </div>

          {/* BANNERS */}
          <div className="flex gap-4 overflow-x-auto pb-8 snap-x scrollbar-hide px-1">
            {BANNERS_PROMO.map((banner) => (
              <div 
                key={banner.id} 
                onClick={() => navigate(`/seccion/${banner.slug}`)}
                className="relative min-w-[280px] h-36 rounded-[2.2rem] overflow-hidden snap-center shadow-lg active:scale-95 transition-transform"
              >
                <img src={banner.img} className="absolute inset-0 w-full h-full object-cover" alt="promo" />
                <div className="absolute inset-0 bg-gradient-to-r from-black/70 via-black/30 to-transparent flex flex-col justify-center px-6">
                  <span className="bg-[#FF441F] text-white text-[8px] font-black px-2 py-0.5 rounded-full w-fit mb-2 uppercase tracking-widest">
                    Exclusivo
                  </span>
                  <h2 className="text-white font-black text-base leading-tight uppercase">{banner.titulo}</h2>
                  <p className="text-white/90 text-[10px] font-bold mt-1 uppercase">{banner.subtitulo}</p>
                </div>
              </div>
            ))}
          </div>

          {/* OFERTAS FLASH */}
          <div className="px-1 mb-4">
            <div className="flex items-center gap-2 mb-4">
              <Zap className="w-4 h-4 text-[#FF441F] fill-[#FF441F]" />
              <h3 className="text-[11px] font-black text-gray-900 uppercase tracking-widest">Cerca de ti</h3>
            </div>
            <div className="space-y-3">
              {ofertasFlash.map((negocio) => (
                <button 
                  key={negocio.id} 
                  onClick={() => navigate(`/seccion/${negocio.slug}`)}
                  className="w-full flex gap-4 bg-white border border-gray-100 p-3 rounded-[2rem] active:scale-[0.98] transition-all hover:shadow-lg text-left"
                >
                  <div className="w-20 h-20 rounded-2xl overflow-hidden flex-shrink-0 bg-gray-50 shadow-sm">
                    <img src={negocio.img} className="w-full h-full object-cover" alt={negocio.nombre} />
                  </div>
                  <div className="flex flex-col justify-center flex-1">
                    <div className="flex justify-between items-start">
                      <h4 className="font-black text-gray-900 text-xs uppercase tracking-tight">{negocio.nombre}</h4>
                      <div className="flex items-center gap-0.5 bg-gray-50 px-1.5 py-0.5 rounded-lg">
                        <Star className="w-2.5 h-2.5 text-yellow-500 fill-yellow-500" />
                        <span className="text-[9px] font-black text-gray-600">{negocio.rating}</span>
                      </div>
                    </div>
                    <p className="text-[#FF441F] text-[10px] font-black uppercase mt-1 leading-tight">{negocio.promo}</p>
                    <div className="flex items-center gap-2 mt-2">
                      <div className="flex items-center gap-1 text-gray-400">
                        <Clock className="w-3 h-3" />
                        <span className="text-[9px] font-bold uppercase">{negocio.tiempo} min</span>
                      </div>
                    </div>
                  </div>
                </button>
              ))}
            </div>
          </div>
        </div>

        {/* NAVBAR INFERIOR - FIJA ABAJO */}
        <div className="absolute bottom-0 left-0 right-0 bg-white/95 backdrop-blur-md border-t border-gray-100 px-4 pt-3 pb-8 flex justify-around items-center z-50">
          <NavItem icon={<HomeIcon className="w-5 h-5" />} label="Inicio" active={true} onClick={() => {}} />
          <NavItem icon={<TagIcon className="w-5 h-5" />} label="Ofertas" active={false} onClick={() => navigate("/ofertas")} />
          <NavItem icon={<HeartIcon className="w-5 h-5" />} label="Favoritos" active={false} onClick={() => navigate("/favoritos")} />
          <NavItem icon={<UserIcon className="w-5 h-5" />} label="Cuenta" active={false} onClick={() => navigate("/cuenta")} />
        </div>
      </div>
      <style>{`.scrollbar-hide::-webkit-scrollbar { display: none; }`}</style>
    </IPhoneFrame>
  );
}

function NavItem({ icon, label, active, onClick }: { icon: any, label: string, active: boolean, onClick: () => void }) {
  return (
    <button onClick={onClick} className={`flex flex-col items-center gap-1 py-1 px-3 transition-all ${active ? "text-[#FF441F] scale-110" : "text-gray-400"}`}>
      {icon}
      <span className="text-[9px] font-black uppercase tracking-widest">{label}</span>
    </button>
  );
}