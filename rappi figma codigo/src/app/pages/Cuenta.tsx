import { 
  User, 
  ChevronRight, 
  Package, 
  CreditCard, 
  MapPin, 
  Bell, 
  ShieldCheck, 
  LogOut,
  Home as HomeIcon,
  Tag as TagIcon,
  Heart as HeartIcon,
  User as UserIcon
} from "lucide-react";
import { useNavigate } from "react-router";
import { IPhoneFrame } from "../components/ui/IPhoneFrame";

export default function Cuenta() {
  const navigate = useNavigate();

  // Data de ejemplo para el historial
  const historialPedidos = [
    { id: 1, nombre: "Little Caesars", fecha: "Ayer, 19:30", img: "https://images.unsplash.com/photo-1513104890138-7c749659a591?w=500" },
    { id: 2, nombre: "S-Mart", fecha: "28 Mar, 12:15", img: "https://images.unsplash.com/photo-1534723452862-4c874018d66d?w=500" },
  ];

  const handleLogout = () => {
    // Lógica para cerrar sesión
    localStorage.removeItem("flash_pedido_activo");
    navigate("/"); // O a tu pantalla de Login
  };

  return (
    <IPhoneFrame>
      <div className="flex flex-col h-full bg-white overflow-hidden relative">
        
        {/* HEADER & PERFIL */}
        <div className="px-6 pt-12 pb-6 bg-white">
          <h1 className="text-xl font-black uppercase tracking-tighter text-gray-900 mb-6">
            Mi <span className="text-[#FF441F]">Cuenta</span>
          </h1>
          
          <div className="flex items-center gap-4">
            <div className="w-20 h-20 rounded-[2rem] overflow-hidden border-4 border-gray-50 shadow-sm">
              <img 
                src="https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?w=500" 
                alt="Profile" 
                className="w-full h-full object-cover"
              />
            </div>
            <div className="flex flex-col">
              <h2 className="font-black text-lg text-gray-900 leading-none uppercase">Alex Rivera</h2>
              <button 
                onClick={() => navigate('/editar-perfil')}
                className="flex items-center gap-1 mt-2 group"
              >
                <span className="text-[10px] font-black text-gray-400 uppercase tracking-widest group-hover:text-[#FF441F] transition-colors">
                  Editar Perfil {">"}
                </span>
              </button>
            </div>
          </div>
        </div>

        {/* ACCESOS RÁPIDOS (FILA) */}
        <div className="px-6 grid grid-cols-2 gap-3 mb-6">
          <button 
            onClick={() => navigate('/mis-pedidos')}
            className="flex flex-col items-center justify-center p-4 bg-gray-50 rounded-[2rem] active:scale-95 transition-transform border border-gray-100"
          >
            <div className="w-10 h-10 bg-white rounded-2xl flex items-center justify-center shadow-sm mb-2">
              <Package className="w-5 h-5 text-[#FF441F]" />
            </div>
            <span className="text-[10px] font-black uppercase text-gray-800">Pedidos</span>
          </button>
          
          <button 
            onClick={() => navigate('/metodos-pago')}
            className="flex flex-col items-center justify-center p-4 bg-gray-50 rounded-[2rem] active:scale-95 transition-transform border border-gray-100"
          >
            <div className="w-10 h-10 bg-white rounded-2xl flex items-center justify-center shadow-sm mb-2">
              <CreditCard className="w-5 h-5 text-[#00BFA5]" />
            </div>
            <span className="text-[10px] font-black uppercase text-gray-800">Pagos</span>
          </button>
        </div>

        <div className="h-[1px] bg-gray-100 mx-6 mb-6" />

        {/* CONTENIDO SCROLLABLE */}
        <div className="flex-1 overflow-y-auto px-6 pb-32 scrollbar-hide">
          
          {/* ÚLTIMOS PEDIDOS */}
          <div className="mb-8">
            <h3 className="text-[11px] font-black text-gray-400 uppercase tracking-widest mb-4">Pedidos Recientes</h3>
            <div className="space-y-3">
              {historialPedidos.map((p) => (
                <div key={p.id} className="flex items-center gap-4 bg-white p-2 rounded-[1.5rem] border border-gray-50 shadow-sm">
                  <div className="w-12 h-12 rounded-xl overflow-hidden flex-shrink-0">
                    <img src={p.img} className="w-full h-full object-cover" alt={p.nombre} />
                  </div>
                  <div className="flex-1">
                    <h4 className="text-xs font-black uppercase text-gray-900 leading-none">{p.nombre}</h4>
                    <p className="text-[10px] font-bold text-gray-400 mt-1 uppercase">{p.fecha}</p>
                  </div>
                  <button className="px-3 py-1.5 bg-gray-50 rounded-xl text-[9px] font-black uppercase text-gray-600 active:bg-[#FF441F] active:text-white transition-colors">
                    Reordenar
                  </button>
                </div>
              ))}
            </div>
          </div>

          {/* AJUSTES DE CUENTA */}
          <div className="mb-6">
            <h3 className="text-[11px] font-black text-gray-400 uppercase tracking-widest mb-4">Mi Configuración</h3>
            <div className="bg-gray-50 rounded-[2.5rem] p-2 space-y-1">
              <AccountOption 
                icon={<MapPin className="w-4 h-4" />} 
                label="Direcciones" 
                onClick={() => navigate('/direcciones')}
              />
              <AccountOption 
                icon={<Bell className="w-4 h-4" />} 
                label="Notificaciones" 
              />
              <AccountOption 
                icon={<ShieldCheck className="w-4 h-4" />} 
                label="Privacidad" 
              />
              <AccountOption 
                icon={<LogOut className="w-4 h-4 text-red-500" />} 
                label="Cerrar Sesión" 
                onClick={() => navigate('/')}
              />
            </div>
          </div>
        </div>

        {/* NAVBAR INFERIOR (Fija) */}
        <div className="absolute bottom-0 left-0 right-0 bg-white/95 backdrop-blur-md border-t border-gray-100 px-4 pt-3 pb-8 flex justify-around items-center z-50">
          <NavItem icon={<HomeIcon className="w-5 h-5" />} label="Inicio" active={false} onClick={() => navigate('/home')} />
          <NavItem icon={<TagIcon className="w-5 h-5" />} label="Ofertas" active={false} onClick={() => navigate('/ofertas')} />
          <NavItem icon={<HeartIcon className="w-5 h-5" />} label="Favoritos" active={false} onClick={() => navigate('/favoritos')} />
          <NavItem icon={<UserIcon className="w-5 h-5" />} label="Cuenta" active={true} onClick={() => {}} />
        </div>
      </div>
      <style>{`.scrollbar-hide::-webkit-scrollbar { display: none; }`}</style>
    </IPhoneFrame>
  );
}

// Subcomponente para las opciones de la lista
function AccountOption({ 
  icon, 
  label, 
  onClick, 
  isLast = false 
}: { 
  icon: any, 
  label: string, 
  onClick?: () => void, 
  isLast?: boolean 
}) {
  return (
    <button 
      onClick={onClick}
      className={`w-full flex items-center justify-between p-4 hover:bg-white rounded-2xl transition-all group ${!isLast ? "border-b border-gray-100" : ""}`}
    >
      <div className="flex items-center gap-3">
        <div className="text-gray-500 group-hover:text-[#FF441F] transition-colors">
          {icon}
        </div>
        <span className="text-xs font-black uppercase text-gray-700 tracking-tight">{label}</span>
      </div>
      <ChevronRight className="w-4 h-4 text-gray-300 group-hover:text-[#FF441F]" />
    </button>
  );
}

// Navbar Item
function NavItem({ icon, label, active, onClick }: { icon: any, label: string, active: boolean, onClick: () => void }) {
  return (
    <button onClick={onClick} className={`flex flex-col items-center gap-1 py-1 px-3 transition-all ${active ? "text-[#FF441F] scale-110" : "text-gray-400"}`}>
      {icon}
      <span className="text-[9px] font-black uppercase tracking-widest">{label}</span>
    </button>
  );
}