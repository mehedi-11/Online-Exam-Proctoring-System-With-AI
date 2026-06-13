import React from 'react';
import { useNavigate, Link } from 'react-router-dom';
import { LogOut, Shield, GraduationCap, User } from 'lucide-react';

export default function Navbar() {
  const navigate = useNavigate();
  const token = localStorage.getItem('token');
  const user = JSON.parse(localStorage.getItem('user') || '{}');

  const handleLogout = () => {
    localStorage.removeItem('token');
    localStorage.removeItem('user');
    navigate('/');
  };

  const getRoleIcon = () => {
    if (user.role === 'admin') return <Shield size={18} className="text-tomato-500" />;
    if (user.role === 'teacher') return <GraduationCap size={18} className="text-tomato-500" />;
    return <User size={18} className="text-tomato-500" />;
  };

  return (
    <nav className="sticky top-0 bg-white/80 backdrop-blur-md border-b border-gray-100 z-40 px-6 py-4 flex justify-between items-center">
      <Link to="/" className="flex items-center gap-2 group">
        <span className="w-9 h-9 rounded-xl bg-tomato-500 flex items-center justify-center text-white font-bold text-lg group-hover:scale-105 smooth-transition shadow-md shadow-tomato-200">
          S
        </span>
        <span className="font-bold text-xl tracking-tight text-dark-900">
          SafeExam<span className="text-tomato-500">.AI</span>
        </span>
      </Link>

      {token && user.role ? (
        <div className="flex items-center gap-5">
          <div className="flex items-center gap-3 bg-gray-50 border border-gray-150 py-1.5 px-3 rounded-xl">
            {user.profile_image ? (
              <img 
                src={`http://localhost:5000${user.profile_image}`} 
                alt="Profile" 
                className="w-7 h-7 rounded-full object-cover border border-tomato-200"
                onError={(e) => { e.target.src = 'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?w=100&h=100&fit=crop'; }}
              />
            ) : (
              <div className="w-7 h-7 rounded-full bg-tomato-100 flex items-center justify-center text-tomato-600">
                {getRoleIcon()}
              </div>
            )}
            <div className="text-left">
              <p className="text-xs font-semibold text-dark-900 leading-3">{user.name}</p>
              <span className="text-[10px] text-gray-500 capitalize">{user.role} {user.role === 'student' && `(${user.id})`}</span>
            </div>
          </div>
          
          <button 
            onClick={handleLogout}
            className="flex items-center gap-2 text-gray-500 hover:text-tomato-600 font-medium py-1.5 px-3 rounded-lg hover:bg-tomato-50 smooth-transition text-sm"
          >
            <LogOut size={16} />
            <span>Logout</span>
          </button>
        </div>
      ) : (
        <Link 
          to="/" 
          className="text-sm font-semibold text-gray-600 hover:text-tomato-500 smooth-transition"
        >
          Home
        </Link>
      )}
    </nav>
  );
}
