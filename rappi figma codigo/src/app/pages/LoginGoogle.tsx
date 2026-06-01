import { useState } from "react";
import { useNavigate } from "react-router";
import { ArrowLeft, ArrowRight, ChevronDown } from "lucide-react";
import { IPhoneFrame } from "../components/ui/IPhoneFrame";

export default function LoginGoogle() {
  const navigate = useNavigate();
  const [isRegistering, setIsRegistering] = useState(false);
  const [formData, setFormData] = useState({
    email: "",
    nombre: "",
    apellidos: "",
    dia: "",
    mes: "",
    anio: "",
    genero: "",
    password: ""
  });

  const handleSubmit = (e: React.FormEvent) => {
    e.preventDefault();
    navigate('/setup-direccion');
  };

  return (
    <IPhoneFrame>
      <div className="flex flex-col h-full bg-white overflow-y-auto">
        {/* Header Ajustado para el Notch */}
        <div className="flex items-center justify-between px-4 pt-12 pb-4 border-b bg-white sticky top-0 z-10">
          <button 
            onClick={() => isRegistering ? setIsRegistering(false) : navigate('/')}
            className="p-2 hover:bg-gray-100 rounded-full transition-colors"
          >
            <ArrowLeft className="w-6 h-6 text-gray-700" />
          </button>
          <div className="flex-1 flex justify-center">
            {/* Logo de Google oficial */}
            <img 
              src="https://upload.wikimedia.org/wikipedia/commons/2/2f/Google_2015_logo.svg" 
              alt="Google" 
              className="h-6 w-auto"
            />
          </div>
          <div className="w-10" />
        </div>

        <div className="px-6 py-8">
          {!isRegistering ? (
            // --- PANTALLA DE LOGIN ---
            <>
              <div className="mb-8">
                <h1 className="text-2xl font-bold text-gray-900 mb-2">Iniciar sesión</h1>
                <p className="text-gray-500 text-sm">Continúa con tu cuenta de Google</p>
              </div>

              <form onSubmit={handleSubmit} className="space-y-6">
                <div>
                  <input
                    type="email"
                    placeholder="Correo electrónico o teléfono"
                    value={formData.email}
                    onChange={(e) => setFormData({ ...formData, email: e.target.value })}
                    className="w-full px-4 py-3 border-2 border-gray-200 rounded-xl focus:border-[#4285F4] focus:outline-none transition-all text-sm"
                  />
                </div>

                <div className="flex justify-between items-center">
                  <a href="#" className="text-xs font-bold text-[#4285F4] hover:underline">
                    ¿Olvidaste el correo?
                  </a>
                </div>

                <div className="flex justify-between items-center pt-8">
                  <button
                    type="button"
                    onClick={() => setIsRegistering(true)}
                    className="text-sm font-bold text-[#4285F4]"
                  >
                    Crear cuenta
                  </button>
                  <button
                    type="submit"
                    className="px-6 py-3 text-white rounded-xl flex items-center gap-2 shadow-lg transition-transform active:scale-95 text-sm font-bold"
                    style={{ backgroundColor: '#4285F4' }}
                  >
                    Siguiente
                    <ArrowRight className="w-4 h-4" />
                  </button>
                </div>
              </form>
            </>
          ) : (
            // --- PANTALLA DE REGISTRO ---
            <>
              <div className="mb-6">
                <h1 className="text-2xl font-bold text-gray-900 mb-1 tracking-tight">Crea tu cuenta</h1>
                <p className="text-gray-500 text-sm">Ingresa tus datos personales</p>
              </div>

              <form onSubmit={handleSubmit} className="space-y-4">
                <div className="grid grid-cols-2 gap-3">
                  <input
                    type="text"
                    placeholder="Nombre"
                    className="px-4 py-3 border-2 border-gray-100 rounded-xl focus:border-[#4285F4] focus:outline-none text-sm bg-gray-50"
                  />
                  <input
                    type="text"
                    placeholder="Apellidos"
                    className="px-4 py-3 border-2 border-gray-100 rounded-xl focus:border-[#4285F4] focus:outline-none text-sm bg-gray-50"
                  />
                </div>

                <div>
                  <label className="block text-[10px] font-bold text-gray-400 uppercase mb-2 ml-1">Fecha de nacimiento</label>
                  <div className="grid grid-cols-3 gap-2">
                    <input
                      type="text"
                      placeholder="Día"
                      className="px-3 py-3 border-2 border-gray-100 rounded-xl focus:border-[#4285F4] focus:outline-none text-sm bg-gray-50 text-center"
                    />
                    <div className="relative">
                      <select className="w-full px-3 py-3 border-2 border-gray-100 rounded-xl focus:border-[#4285F4] focus:outline-none appearance-none text-sm bg-gray-50">
                        <option value="">Mes</option>
                        <option value="1">Ene</option>
                        <option value="2">Feb</option>
                        <option value="3">Mar</option>
                        {/* ... otros meses */}
                      </select>
                      <ChevronDown className="absolute right-2 top-1/2 -translate-y-1/2 w-4 h-4 text-gray-400 pointer-events-none" />
                    </div>
                    <input
                      type="text"
                      placeholder="Año"
                      className="px-3 py-3 border-2 border-gray-100 rounded-xl focus:border-[#4285F4] focus:outline-none text-sm bg-gray-50 text-center"
                    />
                  </div>
                </div>

                <div className="relative">
                  <select className="w-full px-4 py-3 border-2 border-gray-100 rounded-xl focus:border-[#4285F4] focus:outline-none appearance-none text-sm bg-gray-50">
                    <option value="">Género</option>
                    <option value="masculino">Masculino</option>
                    <option value="femenino">Femenino</option>
                  </select>
                  <ChevronDown className="absolute right-4 top-1/2 -translate-y-1/2 w-4 h-4 text-gray-400 pointer-events-none" />
                </div>

                <input
                  type="password"
                  placeholder="Contraseña"
                  className="w-full px-4 py-3 border-2 border-gray-100 rounded-xl focus:border-[#4285F4] focus:outline-none text-sm bg-gray-50"
                />

                <div className="flex justify-center pt-6 mb-10">
                  <button
                    type="submit"
                    className="px-8 py-3 text-white rounded-xl flex items-center gap-2 shadow-md font-bold text-sm"
                    style={{ backgroundColor: '#4285F4' }}
                  >
                    Crear
                    <ArrowRight className="w-4 h-4" />
                  </button>
                </div>
              </form>
            </>
          )}
        </div>
      </div>
    </IPhoneFrame>
  );
}