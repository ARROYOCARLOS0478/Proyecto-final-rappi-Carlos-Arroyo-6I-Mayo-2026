import { useState } from "react";
import { useNavigate } from "react-router";
import { ArrowLeft, ChevronDown, MapPin, User, Palette } from "lucide-react";
import { IPhoneFrame } from "../components/ui/IPhoneFrame";

export default function SetupDireccion() {
  const navigate = useNavigate();
  const [formData, setFormData] = useState({
    calle: "",
    numero: "",
    colonia: "",
    tipoEdificio: "Casa",
    color: "",
    personaRecibe: ""
  });

  const handleContinue = () => {
    navigate('/home-dashboard');
  };

  return (
    <IPhoneFrame>
      <div className="flex flex-col h-full bg-white overflow-y-auto">
        {/* Header */}
        <div className="flex items-center justify-between px-4 pt-12 pb-4 border-b sticky top-0 bg-white z-10">
          <button 
            onClick={() => navigate(-1)}
            className="p-2 hover:bg-gray-100 rounded-full transition-colors"
          >
            <ArrowLeft className="w-6 h-6 text-gray-700" />
          </button>
          <h2 className="font-bold text-gray-800">Detalles de entrega</h2>
          <div className="w-10" />
        </div>

        <div className="px-6 py-8 flex-1 flex flex-col">
          {/* Título */}
          <div className="mb-8 flex flex-col items-center text-center">
            <div className="w-16 h-16 bg-[#00CC99]/10 rounded-full flex items-center justify-center mb-4">
              <MapPin className="w-8 h-8 text-[#00CC99]" />
            </div>
            <h1 className="text-2xl font-black text-gray-900 leading-tight mb-2">
              ¿A dónde llegamos?
            </h1>
            <p className="text-gray-500 text-sm">Completa la información para tu repartidor</p>
          </div>

          <div className="space-y-4">
            {/* Calle */}
            <div>
              <label className="block text-[11px] font-bold text-gray-400 uppercase mb-1.5 ml-1">Calle</label>
              <input
                type="text"
                placeholder="Ej. Av. De la Raza"
                value={formData.calle}
                onChange={(e) => setFormData({ ...formData, calle: e.target.value })}
                className="w-full px-4 py-3 border-2 border-gray-100 rounded-xl focus:border-[#00CC99] focus:outline-none bg-gray-50 text-sm font-medium"
              />
            </div>

            {/* Fila: Número y Colonia */}
            <div className="grid grid-cols-2 gap-4">
               <div>
                  <label className="block text-[11px] font-bold text-gray-400 uppercase mb-1.5 ml-1">Número</label>
                  <input
                    type="text"
                    placeholder="Ej. 1234"
                    value={formData.numero}
                    onChange={(e) => setFormData({ ...formData, numero: e.target.value })}
                    className="w-full px-4 py-3 border-2 border-gray-100 rounded-xl focus:border-[#00CC99] focus:outline-none bg-gray-50 text-sm font-medium"
                  />
               </div>
               <div>
                  <label className="block text-[11px] font-bold text-gray-400 uppercase mb-1.5 ml-1">Colonia</label>
                  <input
                    type="text"
                    placeholder="Ej. Centro"
                    value={formData.colonia}
                    onChange={(e) => setFormData({ ...formData, colonia: e.target.value })}
                    className="w-full px-4 py-3 border-2 border-gray-100 rounded-xl focus:border-[#00CC99] focus:outline-none bg-gray-50 text-sm font-medium"
                  />
               </div>
            </div>

            {/* Tipo de Edificio */}
            <div>
              <label className="block text-[11px] font-bold text-gray-400 uppercase mb-1.5 ml-1">Tipo de edificio</label>
              <div className="relative">
                <select 
                  value={formData.tipoEdificio}
                  onChange={(e) => setFormData({ ...formData, tipoEdificio: e.target.value })}
                  className="w-full px-4 py-3 border-2 border-gray-100 rounded-xl bg-gray-50 focus:border-[#00CC99] focus:outline-none appearance-none text-sm font-bold text-gray-700"
                >
                    <option>Casa</option>
                    <option>Departamento</option>
                    <option>Oficina / Local</option>
                    <option>Privada</option>
                </select>
                <ChevronDown className="absolute right-3 top-1/2 -translate-y-1/2 w-4 h-4 text-gray-400 pointer-events-none" />
              </div>
            </div>

            {/* Color de la fachada */}
            <div>
              <label className="block text-[11px] font-bold text-gray-400 uppercase mb-1.5 ml-1">Color de fachada / portón</label>
              <div className="relative">
                <Palette className="absolute left-4 top-1/2 -translate-y-1/2 w-4 h-4 text-gray-400" />
                <input
                  type="text"
                  placeholder="Ej. Portón negro, casa blanca"
                  value={formData.color}
                  onChange={(e) => setFormData({ ...formData, color: e.target.value })}
                  className="w-full pl-11 pr-4 py-3 border-2 border-gray-100 rounded-xl focus:border-[#00CC99] focus:outline-none bg-gray-50 text-sm font-medium"
                />
              </div>
            </div>

            {/* Persona que recibe */}
            <div>
              <label className="block text-[11px] font-bold text-gray-400 uppercase mb-1.5 ml-1">¿Quién recibe?</label>
              <div className="relative">
                <User className="absolute left-4 top-1/2 -translate-y-1/2 w-4 h-4 text-gray-400" />
                <input
                  type="text"
                  placeholder="Nombre de la persona"
                  value={formData.personaRecibe}
                  onChange={(e) => setFormData({ ...formData, personaRecibe: e.target.value })}
                  className="w-full pl-11 pr-4 py-3 border-2 border-gray-100 rounded-xl focus:border-[#00CC99] focus:outline-none bg-gray-50 text-sm font-medium"
                />
              </div>
            </div>
          </div>

          {/* Botón Final */}
          <div className="mt-auto pt-10 pb-8">
            <button
              onClick={() => navigate('/home')}
              className="w-full py-4 text-white rounded-2xl font-black text-lg shadow-lg shadow-[#00CC99]/30 transition-transform active:scale-95 flex items-center justify-center gap-2"
              style={{ backgroundColor: '#00CC99' }}
            >
              Guardar y continuar
            </button>
          </div>
        </div>
      </div>
    </IPhoneFrame>
  );
}