import React, { useState } from 'react';
import { useParams, useNavigate, Link } from 'react-router-dom';
import axios from 'axios';
import { KeyRound, Mail, UserSquare, ShieldAlert, ArrowLeft, Eye, EyeOff } from 'lucide-react';
import Navbar from '../components/Navbar';

export default function Login() {
  const { role } = useParams(); // 'admin', 'teacher', 'student'
  const navigate = useNavigate();

  const [formData, setFormData] = useState({
    email: '',
    studentId: '',
    password: ''
  });
  const [error, setError] = useState('');
  const [loading, setLoading] = useState(false);
  const [showPassword, setShowPassword] = useState(false);

  const getRoleTitle = () => {
    if (role === 'admin') return 'System Admin';
    if (role === 'teacher') return 'Teacher Console';
    return 'Student Portal';
  };

  const handleChange = (e) => {
    setFormData({ ...formData, [e.target.name]: e.target.value });
    setError('');
  };

  const handleSubmit = async (e) => {
    e.preventDefault();
    setLoading(true);
    setError('');

    let endpoint = '';
    let payload = {};

    if (role === 'admin') {
      endpoint = 'http://localhost:5000/api/auth/login/admin';
      payload = { email: formData.email, password: formData.password };
    } else if (role === 'teacher') {
      endpoint = 'http://localhost:5000/api/auth/login/teacher';
      payload = { email: formData.email, password: formData.password };
    } else {
      endpoint = 'http://localhost:5000/api/auth/login/student';
      payload = { studentId: formData.studentId, password: formData.password };
    }

    try {
      const response = await axios.post(endpoint, payload);
      localStorage.setItem('token', response.data.token);
      localStorage.setItem('user', JSON.stringify(response.data.user));
      
      // Navigate to corresponding dashboard
      navigate(`/dashboard/${role}`);
    } catch (err) {
      setError(err.response?.data?.message || 'Login failed. Please verify credentials.');
    } finally {
      setLoading(false);
    }
  };

  return (
    <div className="min-h-screen bg-gray-50 flex flex-col">
      <Navbar />

      <div className="flex-grow flex items-center justify-center px-4 py-12">
        <div className="bg-white p-8 rounded-2xl shadow-xl w-full max-w-md border border-gray-100 relative overflow-hidden">
          {/* Accent decoration */}
          <div className="absolute top-0 left-0 right-0 h-1.5 bg-tomato-500"></div>

          {/* Back button */}
          <button 
            onClick={() => navigate('/')} 
            className="inline-flex items-center gap-1 text-xs text-gray-400 hover:text-tomato-500 mb-6 smooth-transition"
          >
            <ArrowLeft size={14} />
            <span>Back to portals</span>
          </button>

          <h2 className="text-2xl font-bold text-dark-900 mb-2">{getRoleTitle()}</h2>
          <p className="text-xs text-gray-400 mb-6">Enter your authorized credentials to gain portal access.</p>

          {error && (
            <div className="bg-red-50 border border-red-200 text-red-700 p-3 rounded-xl text-xs flex items-start gap-2 mb-6 animate-fade-in">
              <ShieldAlert size={16} className="mt-0.5 shrink-0" />
              <span>{error}</span>
            </div>
          )}

          <form onSubmit={handleSubmit} className="space-y-5">
            {role === 'student' ? (
              <div>
                <label className="block text-xs font-bold text-gray-700 uppercase tracking-wider mb-2">Student ID</label>
                <div className="relative">
                  <span className="absolute inset-y-0 left-0 pl-3.5 flex items-center text-gray-400">
                    <UserSquare size={18} />
                  </span>
                  <input
                    type="text"
                    name="studentId"
                    value={formData.studentId}
                    onChange={handleChange}
                    required
                    placeholder="e.g. STU1001"
                    className="w-full pl-10 pr-4 py-2.5 bg-gray-50 border border-gray-200 rounded-xl text-sm focus:outline-none focus:bg-white focus:border-tomato-500 focus:ring-1 focus:ring-tomato-500 smooth-transition"
                  />
                </div>
              </div>
            ) : (
              <div>
                <label className="block text-xs font-bold text-gray-700 uppercase tracking-wider mb-2">Email Address</label>
                <div className="relative">
                  <span className="absolute inset-y-0 left-0 pl-3.5 flex items-center text-gray-400">
                    <Mail size={18} />
                  </span>
                  <input
                    type="email"
                    name="email"
                    value={formData.email}
                    onChange={handleChange}
                    required
                    placeholder="name@example.com"
                    className="w-full pl-10 pr-4 py-2.5 bg-gray-50 border border-gray-200 rounded-xl text-sm focus:outline-none focus:bg-white focus:border-tomato-500 focus:ring-1 focus:ring-tomato-500 smooth-transition"
                  />
                </div>
              </div>
            )}

            <div>
              <label className="block text-xs font-bold text-gray-700 uppercase tracking-wider mb-2">Password</label>
              <div className="relative">
                <span className="absolute inset-y-0 left-0 pl-3.5 flex items-center text-gray-400">
                  <KeyRound size={18} />
                </span>
                <input
                  type={showPassword ? "text" : "password"}
                  name="password"
                  value={formData.password}
                  onChange={handleChange}
                  required
                  placeholder="••••••••"
                  className="w-full pl-10 pr-10 py-2.5 bg-gray-50 border border-gray-200 rounded-xl text-sm focus:outline-none focus:bg-white focus:border-tomato-500 focus:ring-1 focus:ring-tomato-500 smooth-transition"
                />
                <button
                  type="button"
                  onClick={() => setShowPassword(!showPassword)}
                  className="absolute inset-y-0 right-0 pr-3.5 flex items-center text-gray-400 hover:text-tomato-500 smooth-transition"
                >
                  {showPassword ? <EyeOff size={18} /> : <Eye size={18} />}
                </button>
              </div>
            </div>

            <button
              type="submit"
              disabled={loading}
              className="tomato-btn w-full py-3 mt-4"
            >
              {loading ? 'Processing...' : 'Sign In'}
            </button>
          </form>

          {role !== 'admin' && (
            <div className="text-center mt-6">
              <span className="text-xs text-gray-400">Don't have an account? </span>
              <Link to={`/register/${role}`} className="text-xs font-semibold text-tomato-500 hover:text-tomato-600 hover:underline smooth-transition">
                Register Request
              </Link>
            </div>
          )}
        </div>
      </div>
    </div>
  );
}
