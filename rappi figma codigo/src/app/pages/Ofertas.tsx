import { useState } from "react";
import { 
  Tag as TagIcon, Home as HomeIcon, Heart as HeartIcon, User as UserIcon,
  Zap, Star, Clock, Heart, ChevronLeft, ShoppingCart 
} from "lucide-react";
import { useNavigate } from "react-router";
import { IPhoneFrame } from "../components/ui/IPhoneFrame";

const NEGOCIOS_CON_OFERTA = [
  { id: "lc", nombre: "Little Caesars", promo: "Pizza Hot-N-Ready -20%", rating: "4.5", tiempo: "15-25", img: "https://images.unsplash.com/photo-1513104890138-7c749659a591?w=500", slug: "restaurantes" },
  { id: "mc", nombre: "McDonald's", promo: "Big Mac Combo -30%", rating: "4.5", tiempo: "15-20", img: "https://images.unsplash.com/photo-1561758033-d89a9ad46330?w=500", slug: "restaurantes" },
  { id: "fsimi", nombre: "F. Similares", promo: "Lunes de Simi -25%", rating: "4.8", tiempo: "15-25", img: "https://images.unsplash.com/photo-1586015555751-63bb77f4322a?w=500", slug: "farmacia" },
];

export default function Ofertas() {
  const navigate = useNavigate();
  const [favoritos, setFavoritos] = useState<string[]>(() => {
    const saved = localStorage.getItem("flash_favoritos");
    return saved ? JSON.parse(saved) : [];
  });

  const toggleFavorito = (id: string) => {
    const nuevo = favoritos.includes(id) ? favoritos.filter(f => f !== id) : [...favoritos, id];
    setFavoritos(nuevo);
    localStorage.setItem("flash_favoritos", JSON.stringify(nuevo));
  };

  return (
    <IPhoneFrame>
      <div className="flex flex-col h-full bg-white overflow-hidden relative">
        {/* HEADER */}
        <div className="px-6 pt-12 pb-4 bg-white border-b border-gray-50 flex items-center justify-between">
          <h1 className="text-xl font-black uppercase italic text-gray-900">Ofertas <span className="text-[#FF441F]">Flash</span></h1>
          <Zap className="w-5 h-5 text-[#FF441F] fill-[#FF441F]" />
        </div>

        <div className="flex-1 overflow-y-auto px-4 py-6 pb-28 scrollbar-hide">
          {/* BANNER PROMO */}
          <div className="w-full h-28 bg-gray-900 rounded-[2rem] mb-6 relative overflow-hidden flex items-center px-6">
             <div className="z-10">
                <h2 className="text-white text-lg font-black uppercase leading-none">Mitad de Precio</h2>
                <p className="text-[#00BFA5] text-[10px] font-black uppercase mt-1">Solo en categorías seleccionadas</p>
             </div>
             <div className="absolute right-[-10px] bottom-[-10px] opacity-20">
                <TagIcon className="w-24 h-24 text-white rotate-12" />
             </div>
          </div>

          <div className="space-y-3">
            {NEGOCIOS_CON_OFERTA.map((negocio) => (
              <div key={negocio.id} className="bg-white border border-gray-100 p-3 rounded-[2.2rem] shadow-sm flex gap-4">
                <div className="w-20 h-20 rounded-2xl overflow-hidden flex-shrink-0">
                  <img src={negocio.img} className="w-full h-full object-cover" />
                </div>
                <div className="flex-1 flex flex-col justify-center">
                  <div className="flex justify-between">
                    <h3 className="font-black text-gray-900 text-xs uppercase">{negocio.nombre}</h3>
                    <Heart 
                      onClick={() => toggleFavorito(negocio.id)}
                      className={`w-5 h-5 ${favoritos.includes(negocio.id) ? "fill-[#FF441F] text-[#FF441F]" : "text-gray-200"}`} 
                    />
                  </div>
                  <p className="text-[#FF441F] text-[10px] font-black uppercase mt-1 italic">{negocio.promo}</p>
                  <div className="flex items-center gap-2 mt-2">
                    <Star className="w-3 h-3 text-yellow-500 fill-yellow-500" />
                    <span className="text-[9px] font-black text-gray-600">{negocio.rating} • {negocio.tiempo} min</span>
                  </div>
                </div>
              </div>
            ))}
          </div>
        </div>

        {/* NAVBAR INFERIOR PERSISTENTE */}
        <div className="absolute bottom-0 left-0 right-0 bg-white/95 backdrop-blur-md border-t border-gray-200 px-4 pt-2 pb-8 flex justify-around items-center z-30">
          <NavItem icon={<HomeIcon className="w-5 h-5" />} label="Inicio" active={false} onClick={() => navigate('/home')} />
          <NavItem icon={<TagIcon className="w-5 h-5" />} label="Ofertas" active={true} onClick={() => navigate('/ofertas')} />
          <NavItem icon={<HeartIcon className="w-5 h-5" />} label="Favoritos" active={false} onClick={() => navigate('/favoritos')} />
          <NavItem icon={<UserIcon className="w-5 h-5" />} label="Cuenta" active={false} onClick={() => navigate('/cuenta')} />
        </div>
      </div>
      <style>{`.scrollbar-hide::-webkit-scrollbar { display: none; }`}</style>
    </IPhoneFrame>
  );
}

// Subcomponente NavItem para reutilizar
function NavItem({ icon, label, active, onClick }: { icon: any, label: string, active: boolean, onClick: () => void }) {
  return (
    <button onClick={onClick} className={`flex flex-col items-center gap-1 py-1 px-3 transition-all ${active ? "text-[#FF441F] scale-110" : "text-gray-400"}`}>
      {icon}
      <span className="text-[9px] font-black uppercase tracking-widest">{label}</span>
    </button>
  );
}