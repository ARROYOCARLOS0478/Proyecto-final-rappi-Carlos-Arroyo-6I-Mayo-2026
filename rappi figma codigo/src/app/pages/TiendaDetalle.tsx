import { useState, useEffect } from "react";
import { useParams, useNavigate } from "react-router";
import { X, Heart, Star, Clock, Bike, Plus } from "lucide-react";
import { IPhoneFrame } from "../components/ui/IPhoneFrame";
import { DATA_GLOBAL, PRODUCTOS_DATA } from "../../data/tiendasData";
import { useCart } from "../../context/CartContext";

export default function TiendaDetalle() {
  const { categoriaId, tiendaId } = useParams();
  const navigate = useNavigate();
  const { totalProductos, totalPrecio, tiendaActualId, agregarAlCarrito } = useCart();
  
  const [tabActiva, setTabActiva] = useState("pizzas");

  // --- LÓGICA DE FAVORITOS CORREGIDA ---
  const [esFavorito, setEsFavorito] = useState(() => {
    const saved = localStorage.getItem("flash_favoritos");
    const favs = saved ? JSON.parse(saved) : [];
    return favs.includes(tiendaId);
  });

  const toggleFavorito = () => {
    const saved = localStorage.getItem("flash_favoritos");
    let favs = saved ? JSON.parse(saved) : [];
    
    if (favs.includes(tiendaId)) {
      favs = favs.filter((id: string) => id !== tiendaId);
      setEsFavorito(false);
    } else {
      favs.push(tiendaId);
      setEsFavorito(true);
    }
    
    localStorage.setItem("flash_favoritos", JSON.stringify(favs));
  };
  // ---------------------------------------

  // Obtener datos dinámicos
  const categoriaData = DATA_GLOBAL[categoriaId || ""];
  const tienda = categoriaData?.tiendas.find((t: any) => t.id === tiendaId);
  const productos = PRODUCTOS_DATA[tiendaId || ""] || [];

  const mostrarCanasta = totalProductos > 0 && tiendaActualId === tiendaId;

  return (
    <IPhoneFrame>
      <div className="flex flex-col h-full bg-white overflow-hidden relative">
        
        {/* HEADER CON IMAGEN Y BOTONES */}
        <div className="relative h-64 w-full">
          <img src={tienda?.img} className="w-full h-full object-cover" alt={tienda?.nombre} />
          <div className="absolute top-12 left-0 right-0 px-6 flex justify-between items-center">
            <button 
              onClick={() => navigate(-1)} 
              className="p-2 bg-white/90 backdrop-blur-md rounded-full shadow-lg active:scale-90 transition-transform"
            >
              <X className="w-5 h-5 text-gray-900" />
            </button>
            <button 
              onClick={toggleFavorito} 
              className="p-2 bg-white/90 backdrop-blur-md rounded-full shadow-lg active:scale-90 transition-transform"
            >
              <Heart className={`w-5 h-5 ${esFavorito ? "fill-red-500 text-red-500" : "text-gray-900"}`} />
            </button>
          </div>
        </div>

        <div className="flex-1 overflow-y-auto px-6 pt-6 pb-28 scrollbar-hide">
          {/* INFO DE LA TIENDA */}
          <h1 className="text-3xl font-black text-gray-900 mb-4 uppercase italic tracking-tighter">
            {tienda?.nombre}
          </h1>

          <div className="bg-gray-100 rounded-3xl p-5 grid grid-cols-3 gap-2 mb-8">
            <div className="flex flex-col items-center border-r border-gray-200">
              <span className="text-[10px] font-bold text-gray-400 uppercase tracking-widest text-center">Entrega</span>
              <div className="flex items-center gap-1 mt-1">
                <Clock className="w-3 h-3 text-gray-800" />
                <span className="text-sm font-black text-gray-800">{tienda?.tiempo} min</span>
              </div>
            </div>
            <div className="flex flex-col items-center border-r border-gray-200">
              <span className="text-[10px] font-bold text-gray-400 uppercase tracking-widest text-center">Envío</span>
              <div className="flex items-center gap-1 mt-1">
                <Bike className="w-3 h-3 text-gray-800" />
                <span className="text-sm font-black text-gray-800">$29.00</span>
              </div>
            </div>
            <div className="flex flex-col items-center">
              <span className="text-[10px] font-bold text-gray-400 uppercase tracking-widest text-center">Calif.</span>
              <div className="flex items-center gap-1 mt-1">
                <Star className="w-3 h-3 text-yellow-500 fill-yellow-500" />
                <span className="text-sm font-black text-gray-800">{tienda?.rating}</span>
              </div>
            </div>
          </div>

          {/* MENÚ TABS */}
          <div className="flex gap-8 border-b border-gray-100 mb-6">
            <button 
              onClick={() => setTabActiva("pizzas")} 
              className={`pb-2 text-lg transition-all ${tabActiva === "pizzas" ? "font-black border-b-4 border-[#FF441F] text-gray-900" : "font-medium text-gray-400"}`}
            >
              Menú
            </button>
            <button 
              onClick={() => setTabActiva("combos")} 
              className={`pb-2 text-lg transition-all ${tabActiva === "combos" ? "font-black border-b-4 border-[#FF441F] text-gray-900" : "font-medium text-gray-400"}`}
            >
              Combos
            </button>
          </div>

          {/* GRID DE PRODUCTOS */}
          {tabActiva === "pizzas" && (
            <div className="grid grid-cols-2 gap-4">
              {productos.map((prod: any) => (
                <div 
                  key={prod.id} 
                  className="flex flex-col gap-2 group relative"
                >
                  {/* Imagen del producto - CLIC VA AL DETALLE */}
                  <div 
                    onClick={() => navigate(`/producto/${categoriaId}/${tiendaId}/${prod.id}`)}
                    className="aspect-square rounded-3xl overflow-hidden shadow-sm bg-gray-50 border border-gray-100 cursor-pointer active:scale-95 transition-transform"
                  >
                    <img src={prod.img} className="w-full h-full object-cover" alt={prod.nombre} />
                  </div>

                  {/* Botón de Agregar Rápido (+) - CLIC AGREGA AL CARRITO */}
                  <button 
                    onClick={(e) => {
                      e.stopPropagation(); // Evita que se dispare el clic del padre
                      agregarAlCarrito(
                        { ...prod, cantidad: 1 }, 
                        tiendaId || "", 
                        tienda?.nombre || ""
                      );
                    }}
                    className="absolute top-28 right-2 bg-[#00BFA5] text-white p-2.5 rounded-2xl shadow-xl shadow-teal-500/30 active:scale-90 transition-all z-20"
                  >
                    <Plus className="w-5 h-5" />
                  </button>

                  {/* Textos del producto - CLIC VA AL DETALLE */}
                  <div 
                    onClick={() => navigate(`/producto/${categoriaId}/${tiendaId}/${prod.id}`)}
                    className="px-1 cursor-pointer"
                  >
                    <div className="flex justify-between items-center">
                      <span className="font-black text-gray-900 text-[12px] uppercase line-clamp-1">{prod.nombre}</span>
                      <span className="text-sm font-black text-[#FF441F]">${prod.precio}</span>
                    </div>
                    <p className="text-[9px] font-bold text-gray-400 uppercase tracking-tight line-clamp-1">Popular • Seleccionado</p>
                  </div>
                </div>
              ))}
            </div>
          )}
        </div>

        {/* BARRA FLOTANTE DE CANASTA */}
        {mostrarCanasta && (
          <div className="absolute bottom-0 left-0 right-0 bg-white border-t border-gray-100 shadow-[0_-10px_30px_rgba(0,0,0,0.1)] px-6 pt-5 pb-10 flex justify-between items-center z-50 rounded-t-[2.5rem] animate-in slide-in-from-bottom duration-300">
            <div className="flex flex-col">
              <span className="text-sm font-black text-gray-900">{totalProductos} productos</span>
              <span className="text-xs font-bold text-[#FF441F]">${totalPrecio.toFixed(2)}</span>
            </div>
            <button 
              onClick={() => navigate('/canasta')}
              className="px-10 py-3.5 rounded-[1.2rem] text-white font-black text-sm uppercase tracking-wider active:scale-95 transition-all shadow-lg bg-[#00BFA5]"
            >
              Ver Canasta
            </button>
          </div>
        )}
      </div>
      <style>{`.scrollbar-hide::-webkit-scrollbar { display: none; }`}</style>
    </IPhoneFrame>
  );
}