import { useState } from "react";
import { useNavigate } from "react-router";
import { ArrowLeft, Home, Briefcase, MapPin, MoreVertical, Plus } from "lucide-react";
import { IPhoneFrame } from "../components/ui/IPhoneFrame";

const direccionesMock = [
  {
    id: 1,
    tipo: "Casa",
    direccion: "Av. Juárez 123, Col. Centro",
    ciudad: "Ciudad Juárez",
    icon: Home
  },
  {
    id: 2,
    tipo: "Trabajo",
    direccion: "Blvd. Independencia 456, Col. Industrial",
    ciudad: "Ciudad Juárez",
    icon: Briefcase
  },
  {
    id: 3,
    tipo: "Otro",
    direccion: "Calle Principal 789, Col. Norte",
    ciudad: "Ciudad Juárez",
    icon: MapPin
  }
];

export default function Direcciones() {
  const navigate = useNavigate();
  const [menuAbierto, setMenuAbierto] = useState<number | null>(null);

  const handleEditarDireccion = (id: number) => {
    setMenuAbierto(null);
    console.log("Editar dirección:", id);
  };

  const handleEliminarDireccion = (id: number) => {
    setMenuAbierto(null);
    console.log("Eliminar dirección:", id);
  };

  return (
    <IPhoneFrame>
      <div className="flex flex-col h-full bg-white overflow-hidden">
        {/* Header con ajuste de Notch */}
        <div className="flex items-center justify-between px-4 pt-12 pb-4 border-b bg-white sticky top-0 z-20">
          <button 
            onClick={() => navigate(-1)}
            className="p-2 hover:bg-gray-100 rounded-full transition-colors"
          >
            <ArrowLeft className="w-6 h-6 text-gray-700" />
          </button>
          <h2 className="font-bold text-gray-800">Mis Direcciones</h2>
          <div className="w-10" />
        </div>

        <div className="flex-1 overflow-y-auto px-6 py-6 pb-24">
          <h1 className="text-2xl font-black text-gray-900 mb-6">Direcciones guardadas</h1>

          {/* Lista de direcciones */}
          <div className="space-y-4 mb-8">
            {direccionesMock.map((direccion) => {
              const Icon = direccion.icon;
              return (
                <div
                  key={direccion.id}
                  className="relative p-4 border-2 border-gray-100 rounded-2xl bg-white shadow-sm"
                >
                  <div className="flex items-start gap-4">
                    <div className="w-12 h-12 rounded-full bg-gray-50 flex items-center justify-center flex-shrink-0 border border-gray-100">
                      <Icon className="w-6 h-6 text-gray-500" />
                    </div>
                    
                    <div className="flex-1">
                      <h3 className="font-extrabold text-gray-800 mb-0.5">{direccion.tipo}</h3>
                      <p className="text-gray-500 text-xs leading-tight">{direccion.direccion}</p>
                      <p className="text-gray-400 text-[10px] font-bold uppercase mt-1">{direccion.ciudad}</p>
                    </div>

                    <div className="relative">
                      <button
                        onClick={() => setMenuAbierto(menuAbierto === direccion.id ? null : direccion.id)}
                        className="p-2 hover:bg-gray-100 rounded-full transition-colors"
                      >
                        <MoreVertical className="w-5 h-5 text-gray-400" />
                      </button>

                      {/* Menú desplegable */}
                      {menuAbierto === direccion.id && (
                        <div className="absolute right-0 top-10 bg-white border border-gray-100 rounded-xl shadow-xl z-30 w-32 overflow-hidden animate-in fade-in zoom-in duration-200">
                          <button
                            onClick={() => handleEditarDireccion(direccion.id)}
                            className="w-full px-4 py-3 text-left hover:bg-gray-50 text-xs font-bold text-gray-700 border-b border-gray-50"
                          >
                            Editar
                          </button>
                          <button
                            onClick={() => handleEliminarDireccion(direccion.id)}
                            className="w-full px-4 py-3 text-left hover:bg-gray-50 text-xs font-bold text-red-500"
                          >
                            Eliminar
                          </button>
                        </div>
                      )}
                    </div>
                  </div>
                </div>
              );
            })}
          </div>

          {/* Botón agregar dirección */}
          <button
            onClick={() => navigate('/setup-direccion')}
            className="w-full py-4 text-white rounded-2xl font-black flex items-center justify-center gap-2 shadow-lg shadow-[#00CC99]/30 transition-transform active:scale-95 mb-10"
            style={{ backgroundColor: '#00CC99' }}
          >
            <Plus className="w-5 h-5 stroke-[3px]" />
            Agregar nueva dirección
          </button>
        </div>
      </div>
    </IPhoneFrame>
  );
}