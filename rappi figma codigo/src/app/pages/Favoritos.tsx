import { useState } from "react";
import { 
  Heart as HeartIcon, Home as HomeIcon, Tag as TagIcon, User as UserIcon,
  Star, ChevronLeft, Heart 
} from "lucide-react";
import { useNavigate } from "react-router";
import { IPhoneFrame } from "../components/ui/IPhoneFrame";
// Importamos tu data real
import { DATA_GLOBAL } from "../../data/tiendasData";

export default function Favoritos() {
  const navigate = useNavigate();
  
  // 1. Obtener los IDs guardados en el teléfono
  const [favoritosIds, setFavoritosIds] = useState<string[]>(() => {
    const saved = localStorage.getItem("flash_favoritos");
    return saved ? JSON.parse(saved) : [];
  });

  // 2. Función para buscar la info de la tienda en DATA_GLOBAL y su slug (categoría)
  const obtenerTiendasFavoritas = () => {
    const resultados: any[] = [];
    
    // Recorremos cada categoría (restaurantes, supermercado, etc.)
    Object.keys(DATA_GLOBAL).forEach((slug) => {
      const categoria = DATA_GLOBAL[slug];
      // Buscamos si alguna tienda de esta categoría está en nuestra lista de favoritos
      categoria.tiendas.forEach((tienda: any) => {
        if (favoritosIds.includes(tienda.id)) {
          resultados.push({ ...tienda, slug }); // Guardamos la tienda + su categoría para el link
        }
      });
    });
    return resultados;
  };

  const listaFavoritos = obtenerTiendasFavoritas();

  const removeFavorito = (id: string) => {
    const nuevo = favoritosIds.filter(f => f !== id);
    setFavoritosIds(nuevo);
    localStorage.setItem("flash_favoritos", JSON.stringify(nuevo));
  };

  return (
    <IPhoneFrame>
      <div className="flex flex-col h-full bg-white overflow-hidden relative">
        {/* HEADER */}
        <div className="px-6 pt-12 pb-4 bg-white flex items-center justify-between border-b border-gray-50">
          <h1 className="text-xl font-black uppercase tracking-tighter text-gray-900">
            Mis <span className="text-[#FF441F]">Favoritos</span>
          </h1>
          <div className="bg-gray-100 p-2 rounded-full">
            <Heart className="w-4 h-4 text-gray-400" />
          </div>
        </div>

        <div className="flex-1 overflow-y-auto px-6 py-4 pb-32 scrollbar-hide">
          {listaFavoritos.length > 0 ? (
            <div className="grid grid-cols-1 gap-6">
              {listaFavoritos.map((negocio) => (
                <div key={negocio.id} className="relative group active:scale-[0.98] transition-transform">
                  {/* Al hacer clic vamos a la tienda usando su slug y su id */}
                  <div 
                    onClick={() => navigate(`/tienda/${negocio.slug}/${negocio.id}`)} 
                    className="w-full h-44 rounded-[2.5rem] overflow-hidden relative shadow-lg cursor-pointer"
                  >
                    <img src={negocio.img} className="w-full h-full object-cover" alt={negocio.nombre} />
                    <div className="absolute inset-0 bg-gradient-to-t from-black/80 via-transparent to-transparent" />
                    <div className="absolute bottom-6 left-6 flex flex-col">
                        <h3 className="text-white font-black text-lg uppercase leading-none">{negocio.nombre}</h3>
                        <div className="flex items-center gap-1 mt-2">
                           <Star className="w-3 h-3 text-yellow-400 fill-yellow-400" />
                           <span className="text-[10px] font-black text-white">{negocio.rating} • {negocio.tiempo} min</span>
                        </div>
                    </div>
                  </div>
                  
                  {/* BOTÓN PARA QUITAR DE FAVORITOS */}
                  <button 
                    onClick={() => removeFavorito(negocio.id)} 
                    className="absolute top-4 right-4 bg-white p-3 rounded-2xl shadow-md active:scale-125 transition-transform z-10"
                  >
                    <Heart className="w-5 h-5 text-[#FF441F] fill-[#FF441F]" />
                  </button>
                </div>
              ))}
            </div>
          ) : (
            <div className="flex flex-col items-center justify-center py-32 text-center">
              <div className="w-16 h-16 bg-gray-50 rounded-full flex items-center justify-center mb-4">
                <HeartIcon className="w-8 h-8 text-gray-200" />
              </div>
              <p className="text-gray-400 text-[10px] font-black uppercase tracking-widest">No tienes favoritos aún</p>
              <button 
                onClick={() => navigate('/')}
                className="mt-6 text-[#FF441F] text-[10px] font-black uppercase border-b-2 border-[#FF441F]"
              >
                Ir a explorar
              </button>
            </div>
          )}
        </div>

        {/* NAVBAR INFERIOR PERSISTENTE */}
        <div className="absolute bottom-0 left-0 right-0 bg-white/95 backdrop-blur-md border-t border-gray-200 px-4 pt-2 pb-8 flex justify-around items-center z-30">
          <NavItem icon={<HomeIcon className="w-5 h-5" />} label="Inicio" active={false} onClick={() => navigate('/home')} />
          <NavItem icon={<TagIcon className="w-5 h-5" />} label="Ofertas" active={false} onClick={() => navigate('/ofertas')} />
          <NavItem icon={<HeartIcon className="w-5 h-5" />} label="Favoritos" active={true} onClick={() => navigate('/favoritos')} />
          <NavItem icon={<UserIcon className="w-5 h-5" />} label="Cuenta" active={false} onClick={() => navigate('/cuenta')} />
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