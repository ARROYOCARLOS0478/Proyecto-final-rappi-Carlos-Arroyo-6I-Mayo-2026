import { useNavigate, useParams } from "react-router";
import { ArrowLeft, ChevronDown, Search, Star, ShoppingCart } from "lucide-react";
import { IPhoneFrame } from "../components/ui/IPhoneFrame";
import { DATA_GLOBAL } from "../../data/tiendasData";
import { useCart } from "../../context/CartContext"; // IMPORTANTE

const tiposComida = [
  { id: 1, nombre: "Pizza", img: "https://cdn-icons-png.flaticon.com/512/3595/3595455.png" },
  { id: 2, nombre: "Comida rápida", img: "https://cdn-icons-png.flaticon.com/512/732/732217.png" },
  { id: 3, nombre: "Hamburguesas", img: "https://cdn-icons-png.flaticon.com/512/872/872242.png" },
  { id: 4, nombre: "Italiana", img: "https://cdn-icons-png.flaticon.com/512/2276/2276931.png" },
  { id: 5, nombre: "Mariscos", img: "https://cdn-icons-png.flaticon.com/512/2927/2927347.png" },
  { id: 6, nombre: "Alitas", img: "https://cdn-icons-png.flaticon.com/512/2619/2619574.png" },
];

export default function SeccionGeneral() {
  const { categoriaId } = useParams(); 
  const navigate = useNavigate();
  
  // USAMOS EL CONTEXTO GLOBAL
  const { totalProductos } = useCart();
  const hayItemsEnCarrito = totalProductos > 0;
  
  const info = DATA_GLOBAL[categoriaId || "restaurantes"];

  if (!info) return null;

  return (
    <IPhoneFrame>
      <div className="flex flex-col h-full bg-white overflow-hidden relative">
        <div className="bg-white px-6 pt-12 pb-2 z-20 flex justify-between items-center">
          <div className="flex items-center gap-3">
            <button onClick={() => navigate("/home")} className="p-1 active:scale-90 transition-transform">
              <ArrowLeft className="w-6 h-6 text-gray-800" />
            </button>
            <div className="flex flex-col">
               <span className="text-[10px] font-black text-[#FF441F] uppercase tracking-widest">{info.titulo}</span>
               <button className="flex items-center gap-1">
                 <span className="text-sm font-black text-gray-800">Av. De la Raza 1234</span>
                 <ChevronDown className="w-4 h-4 text-[#FF441F]" />
               </button>
            </div>
          </div>

          {/* BOTÓN DINÁMICO */}
          {hayItemsEnCarrito && (
            <button 
              onClick={() => navigate('/canasta')} 
              className="p-3 rounded-2xl shadow-xl shadow-teal-500/20 bg-[#00BFA5] relative animate-in zoom-in-50 active:scale-90 transition-all"
            >
              <ShoppingCart className="w-5 h-5 text-white" />
              <span className="absolute -top-1.5 -right-1.5 bg-[#FF441F] text-white text-[10px] font-black w-5 h-5 rounded-full flex items-center justify-center border-2 border-white shadow-sm">
                {totalProductos}
              </span>
            </button>
          )}
        </div>

        <div className="flex-1 overflow-y-auto pb-10 scrollbar-hide">
          <div className="px-6 py-3">
            <div className="relative">
              <Search className="absolute left-4 top-1/2 -translate-y-1/2 w-4 h-4 text-gray-400" />
              <input type="text" placeholder={`¿Qué buscas?`} className="w-full pl-11 pr-4 py-3 bg-white border border-gray-100 rounded-2xl shadow-xl shadow-gray-200/60 text-sm font-medium focus:outline-none" />
            </div>
          </div>

          <div className="mt-4 px-6">
            <h2 className="text-lg font-black text-gray-900 mb-4 italic uppercase">Cerca de ti</h2>
            <div className="grid grid-cols-1 gap-6">
              {info.tiendas.map((tienda: any) => (
                <div key={tienda.id} onClick={() => navigate(`/tienda/${categoriaId}/${tienda.id}`)} className="flex flex-col gap-3 group cursor-pointer">
                  <div className="relative w-full h-44 rounded-[2rem] overflow-hidden shadow-md">
                    <img src={tienda.img} className="w-full h-full object-cover group-active:scale-105 transition-transform duration-500" />
                    <div className="absolute top-4 right-4 bg-white/90 backdrop-blur px-3 py-1 rounded-full flex items-center gap-1 shadow-sm">
                      <Star className="w-3 h-3 text-yellow-500 fill-yellow-500" />
                      <span className="text-xs font-black text-gray-800">{tienda.rating}</span>
                    </div>
                  </div>
                  <div className="px-2 flex justify-between items-center">
                    <h3 className="text-lg font-black text-gray-900 uppercase">{tienda.nombre}</h3>
                    <span className="text-[10px] font-black text-[#FF441F] bg-[#FF441F]/10 px-3 py-1 rounded-full uppercase italic">{tienda.tiempo} min</span>
                  </div>
                </div>
              ))}
            </div>
          </div>
        </div>
      </div>
    </IPhoneFrame>
  );
}