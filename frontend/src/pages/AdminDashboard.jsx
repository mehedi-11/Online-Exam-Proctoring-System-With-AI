import React, { useState, useEffect } from 'react';
import { useNavigate } from 'react-router-dom';
import axios from 'axios';
import { 
  Users, UserCheck, BookOpen, UserCog, ShieldAlert, Check, X, 
  Trash2, AlertTriangle, ShieldCheck, Plus, RefreshCw, UserMinus
} from 'lucide-react';
import Navbar from '../components/Navbar';
import Modal from '../components/Modal';

export default function AdminDashboard() {
  const navigate = useNavigate();
  const token = localStorage.getItem('token');
  const [activeTab, setActiveTab] = useState('overview');
  
  // Data State
  const [teachers, setTeachers] = useState([]);
  const [students, setStudents] = useState([]);
  const [courses, setCourses] = useState([]);
  const [pendingEnrollments, setPendingEnrollments] = useState([]);
  const [profile, setProfile] = useState({ name: '', email: '', password: '' });
  
  // UI State
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState('');
  const [success, setSuccess] = useState('');

  // Modals Open State
  const [isTeacherModalOpen, setIsTeacherModalOpen] = useState(false);
  const [isStudentModalOpen, setIsStudentModalOpen] = useState(false);
  const [isCourseModalOpen, setIsCourseModalOpen] = useState(false);
  const [isAssignModalOpen, setIsAssignModalOpen] = useState(false);
  const [isEnrollModalOpen, setIsEnrollModalOpen] = useState(false);

  // Form Fields State
  const [teacherForm, setTeacherForm] = useState({ name: '', email: '', password: '' });
  const [studentForm, setStudentForm] = useState({ id: '', name: '', email: '', password: '' });
  const [courseForm, setCourseForm] = useState({ name: '', code: '', description: '' });
  const [assignForm, setAssignForm] = useState({ courseId: '', teacherId: '' });
  const [enrollForm, setEnrollForm] = useState({ courseId: '', studentId: '' });

  // Axios Instance with JWT auth
  const api = axios.create({
    headers: { Authorization: `Bearer ${token}` }
  });

  useEffect(() => {
    if (!token) {
      navigate('/login/admin');
      return;
    }
    fetchData();
  }, [token]);

  const fetchData = async () => {
    setLoading(true);
    setError('');
    try {
      const [tRes, sRes, cRes, peRes, pRes] = await Promise.all([
        api.get('http://localhost:5000/api/admin/teachers'),
        api.get('http://localhost:5000/api/admin/students'),
        api.get('http://localhost:5000/api/admin/courses'),
        api.get('http://localhost:5000/api/admin/enrollments/pending'),
        api.get('http://localhost:5000/api/admin/profile')
      ]);

      setTeachers(tRes.data);
      setStudents(sRes.data);
      setCourses(cRes.data);
      setPendingEnrollments(peRes.data);
      setProfile({ ...pRes.data, password: '' });
    } catch (err) {
      console.error(err);
      if (err.response?.status === 401 || err.response?.status === 403) {
        localStorage.clear();
        navigate('/login/admin');
      } else {
        setError('Failed to fetch dashboard data.');
      }
    } finally {
      setLoading(false);
    }
  };

  // Helper flash success message
  const triggerSuccess = (msg) => {
    setSuccess(msg);
    setTimeout(() => setSuccess(''), 4000);
  };

  // --- Profile Actions ---
  const handleProfileSubmit = async (e) => {
    e.preventDefault();
    setError('');
    try {
      await api.put('http://localhost:5000/api/admin/profile', profile);
      triggerSuccess('Profile credentials updated successfully');
      fetchData();
    } catch (err) {
      setError(err.response?.data?.message || 'Error updating profile');
    }
  };

  // --- Teacher Actions ---
  const handleAddTeacher = async (e) => {
    e.preventDefault();
    try {
      await api.post('http://localhost:5000/api/admin/teachers', teacherForm);
      setIsTeacherModalOpen(false);
      setTeacherForm({ name: '', email: '', password: '' });
      triggerSuccess('Teacher added successfully');
      fetchData();
    } catch (err) {
      setError(err.response?.data?.message || 'Error adding teacher');
    }
  };

  const handleUpdateTeacherStatus = async (id, currentStatus) => {
    const nextStatus = currentStatus === 'approved' ? 'suspended' : 'approved';
    try {
      await api.put(`http://localhost:5000/api/admin/teachers/${id}/status`, { status: nextStatus });
      triggerSuccess(`Teacher status updated to ${nextStatus}`);
      fetchData();
    } catch (err) {
      setError('Error updating status');
    }
  };

  const handleDeleteTeacher = async (id) => {
    if (!window.confirm('Are you sure you want to delete this teacher?')) return;
    try {
      await api.delete(`http://localhost:5000/api/admin/teachers/${id}`);
      triggerSuccess('Teacher deleted successfully');
      fetchData();
    } catch (err) {
      setError('Error deleting teacher');
    }
  };

  // --- Student Actions ---
  const handleAddStudent = async (e) => {
    e.preventDefault();
    try {
      await api.post('http://localhost:5000/api/admin/students', studentForm);
      setIsStudentModalOpen(false);
      setStudentForm({ id: '', name: '', email: '', password: '' });
      triggerSuccess('Student added successfully');
      fetchData();
    } catch (err) {
      setError(err.response?.data?.message || 'Error adding student');
    }
  };

  const handleUpdateStudentStatus = async (id, currentStatus) => {
    const nextStatus = currentStatus === 'approved' ? 'suspended' : 'approved';
    try {
      await api.put(`http://localhost:5000/api/admin/students/${id}/status`, { status: nextStatus });
      triggerSuccess(`Student status updated to ${nextStatus}`);
      fetchData();
    } catch (err) {
      setError('Error updating student status');
    }
  };

  const handleDeleteStudent = async (id) => {
    if (!window.confirm('Are you sure you want to delete this student?')) return;
    try {
      await api.delete(`http://localhost:5000/api/admin/students/${id}`);
      triggerSuccess('Student deleted successfully');
      fetchData();
    } catch (err) {
      setError('Error deleting student');
    }
  };

  // --- Course Actions ---
  const handleAddCourse = async (e) => {
    e.preventDefault();
    try {
      await api.post('http://localhost:5000/api/admin/courses', courseForm);
      setIsCourseModalOpen(false);
      setCourseForm({ name: '', code: '', description: '' });
      triggerSuccess('Course created successfully');
      fetchData();
    } catch (err) {
      setError(err.response?.data?.message || 'Error creating course');
    }
  };

  const handleDeleteCourse = async (id) => {
    if (!window.confirm('Are you sure you want to delete this course?')) return;
    try {
      await api.delete(`http://localhost:5000/api/admin/courses/${id}`);
      triggerSuccess('Course deleted successfully');
      fetchData();
    } catch (err) {
      setError('Error deleting course');
    }
  };

  const handleAssignTeacher = async (e) => {
    e.preventDefault();
    try {
      await api.post('http://localhost:5000/api/admin/courses/assign-teacher', assignForm);
      setIsAssignModalOpen(false);
      setAssignForm({ courseId: '', teacherId: '' });
      triggerSuccess('Teacher assigned successfully');
      fetchData();
    } catch (err) {
      setError(err.response?.data?.message || 'Error assigning teacher');
    }
  };

  const handleEnrollStudent = async (e) => {
    e.preventDefault();
    try {
      await api.post('http://localhost:5000/api/admin/courses/enroll-student', enrollForm);
      setIsEnrollModalOpen(false);
      setEnrollForm({ courseId: '', studentId: '' });
      triggerSuccess('Student enrolled successfully');
      fetchData();
    } catch (err) {
      setError(err.response?.data?.message || 'Error enrolling student');
    }
  };

  const handleApproveEnrollment = async (courseId, studentId) => {
    try {
      await api.post('http://localhost:5000/api/admin/enrollments/approve', { courseId, studentId });
      triggerSuccess('Student enrollment request approved');
      fetchData();
    } catch (err) {
      setError('Error approving enrollment request');
    }
  };

  return (
    <div className="min-h-screen bg-gray-50 flex flex-col">
      <Navbar />

      <div className="flex-grow max-w-7xl w-full mx-auto px-6 py-10">
        
        {/* Header Summary */}
        <div className="flex flex-col md:flex-row justify-between items-start md:items-center gap-4 mb-8">
          <div>
            <h1 className="text-3xl font-bold text-dark-900">Admin Control Center</h1>
            <p className="text-gray-400 text-sm">Oversee registrations, user accounts, and courses.</p>
          </div>
          <button 
            onClick={fetchData} 
            className="tomato-btn-outline py-2 text-xs flex items-center gap-1.5"
          >
            <RefreshCw size={14} className={loading ? 'animate-spin' : ''} />
            <span>Reload Dashboard</span>
          </button>
        </div>

        {/* Global Notifications */}
        {success && (
          <div className="bg-green-50 border border-green-200 text-green-700 py-3 px-5 rounded-xl text-xs font-semibold mb-6 flex items-center gap-2 animate-fade-in shadow-sm">
            <ShieldCheck size={16} />
            <span>{success}</span>
          </div>
        )}

        {error && (
          <div className="bg-red-50 border border-red-200 text-red-700 py-3 px-5 rounded-xl text-xs font-semibold mb-6 flex items-center gap-2 animate-fade-in shadow-sm">
            <ShieldAlert size={16} />
            <span>{error}</span>
          </div>
        )}

        {/* Tab Navigation */}
        <div className="flex border-b border-gray-200 gap-2 mb-8 overflow-x-auto pb-1">
          {[
            { id: 'overview', label: 'Pending Approvals', icon: UserCheck },
            { id: 'teachers', label: 'Teachers', icon: Users },
            { id: 'students', label: 'Students', icon: Users },
            { id: 'courses', label: 'Courses & Assignments', icon: BookOpen },
            { id: 'profile', label: 'Credentials Profile', icon: UserCog }
          ].map(tab => (
            <button
              key={tab.id}
              onClick={() => { setActiveTab(tab.id); setError(''); }}
              className={`flex items-center gap-2 px-5 py-3 font-semibold text-sm rounded-t-xl transition-all ${
                activeTab === tab.id 
                  ? 'border-b-2 border-tomato-500 text-tomato-600 bg-white shadow-sm'
                  : 'text-gray-500 hover:text-dark-900 hover:bg-gray-100/50'
              }`}
            >
              <tab.icon size={16} />
              <span>{tab.label}</span>
            </button>
          ))}
        </div>

        {/* Dynamic Content Sections */}
        <div className="bg-white rounded-2xl border border-gray-150 p-6 md:p-8 shadow-sm">
          
          {/* TAB: OVERVIEW / APPROVALS */}
          {activeTab === 'overview' && (
            <div className="space-y-8 animate-fade-in">
              {/* User registration approvals */}
              <div>
                <h3 className="text-lg font-bold text-dark-900 mb-4 flex items-center gap-2">
                  <UserCheck size={18} className="text-tomato-500" />
                  <span>Pending Registrations (Awaiting Approval)</span>
                </h3>

                <div className="overflow-x-auto">
                  <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
                    {/* Teachers Pending */}
                    <div className="border border-gray-150 rounded-xl p-5 bg-gray-50/55">
                      <h4 className="font-bold text-xs text-gray-500 uppercase tracking-widest mb-3">Pending Teachers</h4>
                      {teachers.filter(t => t.status === 'pending').length === 0 ? (
                        <p className="text-xs text-gray-400 py-2">No pending teacher approvals.</p>
                      ) : (
                        <div className="space-y-3">
                          {teachers.filter(t => t.status === 'pending').map(teacher => (
                            <div key={teacher.id} className="flex justify-between items-center bg-white border border-gray-150 p-3 rounded-lg text-xs">
                              <div>
                                <p className="font-bold text-dark-900">{teacher.name}</p>
                                <span className="text-gray-400">{teacher.email}</span>
                              </div>
                              <div className="flex gap-2">
                                <button 
                                  onClick={() => handleUpdateTeacherStatus(teacher.id, 'pending')}
                                  className="p-1 text-green-600 hover:bg-green-50 rounded-lg smooth-transition"
                                  title="Approve"
                                >
                                  <Check size={18} />
                                </button>
                                <button 
                                  onClick={() => handleDeleteTeacher(teacher.id)}
                                  className="p-1 text-red-600 hover:bg-red-50 rounded-lg smooth-transition"
                                  title="Reject"
                                >
                                  <X size={18} />
                                </button>
                              </div>
                            </div>
                          ))}
                        </div>
                      )}
                    </div>

                    {/* Students Pending */}
                    <div className="border border-gray-150 rounded-xl p-5 bg-gray-50/55">
                      <h4 className="font-bold text-xs text-gray-500 uppercase tracking-widest mb-3">Pending Students</h4>
                      {students.filter(s => s.status === 'pending').length === 0 ? (
                        <p className="text-xs text-gray-400 py-2">No pending student approvals.</p>
                      ) : (
                        <div className="space-y-3">
                          {students.filter(s => s.status === 'pending').map(student => (
                            <div key={student.id} className="flex justify-between items-center bg-white border border-gray-150 p-3 rounded-lg text-xs">
                              <div>
                                <p className="font-bold text-dark-900">{student.name} ({student.id})</p>
                                <span className="text-gray-400">{student.email}</span>
                              </div>
                              <div className="flex gap-2">
                                <button 
                                  onClick={() => handleUpdateStudentStatus(student.id, 'pending')}
                                  className="p-1 text-green-600 hover:bg-green-50 rounded-lg smooth-transition"
                                  title="Approve"
                                >
                                  <Check size={18} />
                                </button>
                                <button 
                                  onClick={() => handleDeleteStudent(student.id)}
                                  className="p-1 text-red-600 hover:bg-red-50 rounded-lg smooth-transition"
                                  title="Reject"
                                >
                                  <X size={18} />
                                </button>
                              </div>
                            </div>
                          ))}
                        </div>
                      )}
                    </div>
                  </div>
                </div>
              </div>

              {/* Course enrollment approvals */}
              <div>
                <h3 className="text-lg font-bold text-dark-900 mb-4 flex items-center gap-2">
                  <BookOpen size={18} className="text-tomato-500" />
                  <span>Pending Course Enrollment Requests</span>
                </h3>

                {pendingEnrollments.length === 0 ? (
                  <div className="border border-gray-150 bg-gray-50 rounded-xl py-6 text-center text-xs text-gray-400">
                    No active course enrollment requests.
                  </div>
                ) : (
                  <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
                    {pendingEnrollments.map((req, idx) => (
                      <div key={idx} className="flex justify-between items-center bg-white border border-gray-150 p-4 rounded-xl text-xs">
                        <div>
                          <p className="font-bold text-dark-900">{req.student_name} ({req.student_id})</p>
                          <p className="text-gray-400">Requested: <span className="font-semibold text-tomato-500">{req.course_code} - {req.course_name}</span></p>
                        </div>
                        <button 
                          onClick={() => handleApproveEnrollment(req.course_id, req.student_id)}
                          className="tomato-btn py-1.5 px-3 text-[11px] rounded-lg"
                        >
                          <Check size={14} />
                          <span>Approve</span>
                        </button>
                      </div>
                    ))}
                  </div>
                )}
              </div>
            </div>
          )}

          {/* TAB: TEACHERS */}
          {activeTab === 'teachers' && (
            <div className="space-y-6 animate-fade-in">
              <div className="flex justify-between items-center">
                <h3 className="text-lg font-bold text-dark-900">Registered Instructors ({teachers.length})</h3>
                <button 
                  onClick={() => setIsTeacherModalOpen(true)}
                  className="tomato-btn py-2 text-xs flex items-center gap-1"
                >
                  <Plus size={14} />
                  <span>Add Teacher</span>
                </button>
              </div>

              <div className="overflow-x-auto border border-gray-150 rounded-xl">
                <table className="w-full text-left text-xs border-collapse">
                  <thead>
                    <tr className="bg-gray-50 border-b border-gray-150 text-gray-500 font-bold uppercase tracking-wider">
                      <th className="p-4">Name</th>
                      <th className="p-4">Email</th>
                      <th className="p-4">Status</th>
                      <th className="p-4">Joined Date</th>
                      <th className="p-4 text-center">Actions</th>
                    </tr>
                  </thead>
                  <tbody className="divide-y divide-gray-150">
                    {teachers.map(teacher => (
                      <tr key={teacher.id} className="hover:bg-gray-50/50">
                        <td className="p-4 font-bold text-dark-900">{teacher.name}</td>
                        <td className="p-4">{teacher.email}</td>
                        <td className="p-4">
                          <span className={`px-2.5 py-1 rounded-full text-[10px] font-bold ${
                            teacher.status === 'approved' ? 'bg-green-50 text-green-700 border border-green-200' :
                            teacher.status === 'suspended' ? 'bg-red-50 text-red-700 border border-red-200' :
                            'bg-yellow-50 text-yellow-700 border border-yellow-200'
                          }`}>
                            {teacher.status}
                          </span>
                        </td>
                        <td className="p-4">{new Date(teacher.joining_date).toLocaleDateString()}</td>
                        <td className="p-4 flex justify-center gap-2">
                          <button
                            onClick={() => handleUpdateTeacherStatus(teacher.id, teacher.status)}
                            className={`px-3 py-1.5 rounded-lg border font-semibold flex items-center gap-1.5 ${
                              teacher.status === 'approved' 
                                ? 'border-red-200 text-red-600 hover:bg-red-50' 
                                : 'border-green-200 text-green-600 hover:bg-green-50'
                            }`}
                          >
                            {teacher.status === 'approved' ? <UserMinus size={13} /> : <UserCheck size={13} />}
                            <span>{teacher.status === 'approved' ? 'Suspend' : 'Activate'}</span>
                          </button>
                          <button
                            onClick={() => handleDeleteTeacher(teacher.id)}
                            className="p-1.5 text-gray-400 hover:text-red-500 rounded-lg"
                            title="Delete"
                          >
                            <Trash2 size={16} />
                          </button>
                        </td>
                      </tr>
                    ))}
                  </tbody>
                </table>
              </div>
            </div>
          )}

          {/* TAB: STUDENTS */}
          {activeTab === 'students' && (
            <div className="space-y-6 animate-fade-in">
              <div className="flex justify-between items-center">
                <h3 className="text-lg font-bold text-dark-900">Registered Students ({students.length})</h3>
                <button 
                  onClick={() => setIsStudentModalOpen(true)}
                  className="tomato-btn py-2 text-xs flex items-center gap-1"
                >
                  <Plus size={14} />
                  <span>Add Student</span>
                </button>
              </div>

              <div className="overflow-x-auto border border-gray-150 rounded-xl">
                <table className="w-full text-left text-xs border-collapse">
                  <thead>
                    <tr className="bg-gray-50 border-b border-gray-150 text-gray-500 font-bold uppercase tracking-wider">
                      <th className="p-4">Student ID</th>
                      <th className="p-4">Name</th>
                      <th className="p-4">Email</th>
                      <th className="p-4">Status</th>
                      <th className="p-4 text-center">Actions</th>
                    </tr>
                  </thead>
                  <tbody className="divide-y divide-gray-150">
                    {students.map(student => (
                      <tr key={student.id} className="hover:bg-gray-50/50">
                        <td className="p-4 font-mono font-bold text-dark-900">{student.id}</td>
                        <td className="p-4 font-bold text-dark-900">{student.name}</td>
                        <td className="p-4">{student.email}</td>
                        <td className="p-4">
                          <span className={`px-2.5 py-1 rounded-full text-[10px] font-bold ${
                            student.status === 'approved' ? 'bg-green-50 text-green-700 border border-green-200' :
                            student.status === 'suspended' ? 'bg-red-50 text-red-700 border border-red-200' :
                            'bg-yellow-50 text-yellow-700 border border-yellow-200'
                          }`}>
                            {student.status}
                          </span>
                        </td>
                        <td className="p-4 flex justify-center gap-2">
                          <button
                            onClick={() => handleUpdateStudentStatus(student.id, student.status)}
                            className={`px-3 py-1.5 rounded-lg border font-semibold flex items-center gap-1.5 ${
                              student.status === 'approved' 
                                ? 'border-red-200 text-red-600 hover:bg-red-50' 
                                : 'border-green-200 text-green-600 hover:bg-green-50'
                            }`}
                          >
                            {student.status === 'approved' ? <UserMinus size={13} /> : <UserCheck size={13} />}
                            <span>{student.status === 'approved' ? 'Suspend' : 'Activate'}</span>
                          </button>
                          <button
                            onClick={() => handleDeleteStudent(student.id)}
                            className="p-1.5 text-gray-400 hover:text-red-500 rounded-lg"
                            title="Delete"
                          >
                            <Trash2 size={16} />
                          </button>
                        </td>
                      </tr>
                    ))}
                  </tbody>
                </table>
              </div>
            </div>
          )}

          {/* TAB: COURSES */}
          {activeTab === 'courses' && (
            <div className="space-y-6 animate-fade-in">
              <div className="flex flex-wrap justify-between items-center gap-4">
                <h3 className="text-lg font-bold text-dark-900">System Course Catalog ({courses.length})</h3>
                <div className="flex gap-2">
                  <button 
                    onClick={() => setIsCourseModalOpen(true)}
                    className="tomato-btn py-2 text-xs"
                  >
                    <Plus size={14} />
                    <span>Create Course</span>
                  </button>
                  <button 
                    onClick={() => setIsAssignModalOpen(true)}
                    className="tomato-btn-outline py-2 text-xs"
                  >
                    <span>Assign Instructor</span>
                  </button>
                  <button 
                    onClick={() => setIsEnrollModalOpen(true)}
                    className="tomato-btn-outline py-2 text-xs"
                  >
                    <span>Direct Enroll Student</span>
                  </button>
                </div>
              </div>

              <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
                {courses.map(course => (
                  <div key={course.id} className="border border-gray-150 p-5 rounded-2xl relative bg-white shadow-sm flex flex-col justify-between">
                    <div>
                      <div className="flex justify-between items-start mb-3">
                        <span className="bg-tomato-50 text-tomato-600 px-3 py-1 rounded-xl text-[10px] font-bold border border-tomato-100 uppercase">
                          {course.code}
                        </span>
                        <button 
                          onClick={() => handleDeleteCourse(course.id)}
                          className="text-gray-400 hover:text-red-600 smooth-transition"
                          title="Delete Course"
                        >
                          <Trash2 size={16} />
                        </button>
                      </div>
                      <h4 className="font-bold text-dark-900 text-sm mb-1">{course.name}</h4>
                      <p className="text-xs text-gray-400 line-clamp-2 mb-4 leading-normal">{course.description || 'No description provided.'}</p>
                    </div>

                    <div className="border-t border-gray-100 pt-4 flex justify-between items-center text-xs">
                      <div>
                        <span className="text-gray-400 block text-[10px] uppercase font-semibold">Instructor</span>
                        <span className="font-semibold text-dark-900">
                          {course.teacher_name ? course.teacher_name : 'Unassigned'}
                        </span>
                      </div>
                      <div className="text-right">
                        <span className="text-gray-400 block text-[10px] uppercase font-semibold">Enrolled Students</span>
                        <span className="font-semibold text-tomato-500">{course.enrolled_students_count} Students</span>
                      </div>
                    </div>
                  </div>
                ))}
              </div>
            </div>
          )}

          {/* TAB: PROFILE CREDENTIALS */}
          {activeTab === 'profile' && (
            <div className="max-w-md animate-fade-in">
              <h3 className="text-lg font-bold text-dark-900 mb-6">Manage Credentials</h3>
              
              <form onSubmit={handleProfileSubmit} className="space-y-5">
                <div>
                  <label className="block text-xs font-bold text-gray-700 uppercase tracking-wider mb-2">Display Name</label>
                  <input
                    type="text"
                    required
                    value={profile.name}
                    onChange={(e) => setProfile({ ...profile, name: e.target.value })}
                    className="w-full px-4 py-2.5 bg-gray-50 border border-gray-200 rounded-xl text-sm focus:outline-none focus:bg-white focus:border-tomato-500 focus:ring-1 focus:ring-tomato-500 smooth-transition"
                  />
                </div>

                <div>
                  <label className="block text-xs font-bold text-gray-700 uppercase tracking-wider mb-2">Email Address</label>
                  <input
                    type="email"
                    required
                    value={profile.email}
                    onChange={(e) => setProfile({ ...profile, email: e.target.value })}
                    className="w-full px-4 py-2.5 bg-gray-50 border border-gray-200 rounded-xl text-sm focus:outline-none focus:bg-white focus:border-tomato-500 focus:ring-1 focus:ring-tomato-500 smooth-transition"
                  />
                </div>

                <div>
                  <label className="block text-xs font-bold text-gray-700 uppercase tracking-wider mb-2">Change Password (Leave blank to keep current)</label>
                  <input
                    type="password"
                    placeholder="••••••••"
                    value={profile.password}
                    onChange={(e) => setProfile({ ...profile, password: e.target.value })}
                    className="w-full px-4 py-2.5 bg-gray-50 border border-gray-200 rounded-xl text-sm focus:outline-none focus:bg-white focus:border-tomato-500 focus:ring-1 focus:ring-tomato-500 smooth-transition"
                  />
                </div>

                <button type="submit" className="tomato-btn py-3 w-full mt-4">
                  Update Credentials
                </button>
              </form>
            </div>
          )}
        </div>
      </div>

      {/* POPUP MODALS */}

      {/* Modal: Add Teacher */}
      <Modal isOpen={isTeacherModalOpen} onClose={() => setIsTeacherModalOpen(false)} title="Add New Teacher">
        <form onSubmit={handleAddTeacher} className="space-y-4">
          <div>
            <label className="block text-xs font-bold text-gray-700 mb-1.5 uppercase">Full Name</label>
            <input 
              type="text" required placeholder="e.g. Professor Sarah Connor"
              value={teacherForm.name} 
              onChange={e => setTeacherForm({ ...teacherForm, name: e.target.value })}
              className="w-full px-3 py-2 bg-gray-50 border border-gray-200 rounded-xl text-sm focus:outline-none focus:border-tomato-500 smooth-transition"
            />
          </div>
          <div>
            <label className="block text-xs font-bold text-gray-700 mb-1.5 uppercase">Email Address</label>
            <input 
              type="email" required placeholder="e.g. sarah@university.edu"
              value={teacherForm.email} 
              onChange={e => setTeacherForm({ ...teacherForm, email: e.target.value })}
              className="w-full px-3 py-2 bg-gray-50 border border-gray-200 rounded-xl text-sm focus:outline-none focus:border-tomato-500 smooth-transition"
            />
          </div>
          <div>
            <label className="block text-xs font-bold text-gray-700 mb-1.5 uppercase">Password</label>
            <input 
              type="password" required placeholder="••••••••"
              value={teacherForm.password} 
              onChange={e => setTeacherForm({ ...teacherForm, password: e.target.value })}
              className="w-full px-3 py-2 bg-gray-50 border border-gray-200 rounded-xl text-sm focus:outline-none focus:border-tomato-500 smooth-transition"
            />
          </div>
          <button type="submit" className="tomato-btn w-full py-2.5 mt-2">Submit (Approve Directly)</button>
        </form>
      </Modal>

      {/* Modal: Add Student */}
      <Modal isOpen={isStudentModalOpen} onClose={() => setIsStudentModalOpen(false)} title="Add New Student">
        <form onSubmit={handleAddStudent} className="space-y-4">
          <div>
            <label className="block text-xs font-bold text-gray-700 mb-1.5 uppercase">Student ID</label>
            <input 
              type="text" required placeholder="e.g. STU2050"
              value={studentForm.id} 
              onChange={e => setStudentForm({ ...studentForm, id: e.target.value })}
              className="w-full px-3 py-2 bg-gray-50 border border-gray-200 rounded-xl text-sm focus:outline-none focus:border-tomato-500 smooth-transition"
            />
          </div>
          <div>
            <label className="block text-xs font-bold text-gray-700 mb-1.5 uppercase">Full Name</label>
            <input 
              type="text" required placeholder="e.g. John Miller"
              value={studentForm.name} 
              onChange={e => setStudentForm({ ...studentForm, name: e.target.value })}
              className="w-full px-3 py-2 bg-gray-50 border border-gray-200 rounded-xl text-sm focus:outline-none focus:border-tomato-500 smooth-transition"
            />
          </div>
          <div>
            <label className="block text-xs font-bold text-gray-700 mb-1.5 uppercase">Email Address</label>
            <input 
              type="email" required placeholder="e.g. john@student.edu"
              value={studentForm.email} 
              onChange={e => setStudentForm({ ...studentForm, email: e.target.value })}
              className="w-full px-3 py-2 bg-gray-50 border border-gray-200 rounded-xl text-sm focus:outline-none focus:border-tomato-500 smooth-transition"
            />
          </div>
          <div>
            <label className="block text-xs font-bold text-gray-700 mb-1.5 uppercase">Password</label>
            <input 
              type="password" required placeholder="••••••••"
              value={studentForm.password} 
              onChange={e => setStudentForm({ ...studentForm, password: e.target.value })}
              className="w-full px-3 py-2 bg-gray-50 border border-gray-200 rounded-xl text-sm focus:outline-none focus:border-tomato-500 smooth-transition"
            />
          </div>
          <button type="submit" className="tomato-btn w-full py-2.5 mt-2">Submit (Approve Directly)</button>
        </form>
      </Modal>

      {/* Modal: Create Course */}
      <Modal isOpen={isCourseModalOpen} onClose={() => setIsCourseModalOpen(false)} title="Create New Course">
        <form onSubmit={handleAddCourse} className="space-y-4">
          <div>
            <label className="block text-xs font-bold text-gray-700 mb-1.5 uppercase">Course Code</label>
            <input 
              type="text" required placeholder="e.g. CS101"
              value={courseForm.code} 
              onChange={e => setCourseForm({ ...courseForm, code: e.target.value })}
              className="w-full px-3 py-2 bg-gray-50 border border-gray-200 rounded-xl text-sm focus:outline-none focus:border-tomato-500 smooth-transition"
            />
          </div>
          <div>
            <label className="block text-xs font-bold text-gray-700 mb-1.5 uppercase">Course Title</label>
            <input 
              type="text" required placeholder="e.g. Introduction to Programming"
              value={courseForm.name} 
              onChange={e => setCourseForm({ ...courseForm, name: e.target.value })}
              className="w-full px-3 py-2 bg-gray-50 border border-gray-200 rounded-xl text-sm focus:outline-none focus:border-tomato-500 smooth-transition"
            />
          </div>
          <div>
            <label className="block text-xs font-bold text-gray-700 mb-1.5 uppercase">Course Description</label>
            <textarea 
              placeholder="Brief course objectives and syllabus details..."
              value={courseForm.description} 
              onChange={e => setCourseForm({ ...courseForm, description: e.target.value })}
              className="w-full px-3 py-2 bg-gray-50 border border-gray-200 rounded-xl text-sm focus:outline-none focus:border-tomato-500 smooth-transition h-24 resize-none"
            />
          </div>
          <button type="submit" className="tomato-btn w-full py-2.5 mt-2">Create Course</button>
        </form>
      </Modal>

      {/* Modal: Assign Instructor */}
      <Modal isOpen={isAssignModalOpen} onClose={() => setIsAssignModalOpen(false)} title="Assign Teacher to Course">
        <form onSubmit={handleAssignTeacher} className="space-y-4">
          <div>
            <label className="block text-xs font-bold text-gray-700 mb-1.5 uppercase">Select Course</label>
            <select
              required
              value={assignForm.courseId}
              onChange={e => setAssignForm({ ...assignForm, courseId: e.target.value })}
              className="w-full px-3 py-2 bg-gray-50 border border-gray-200 rounded-xl text-sm focus:outline-none focus:border-tomato-500 smooth-transition"
            >
              <option value="">-- Choose Course --</option>
              {courses.map(course => (
                <option key={course.id} value={course.id}>{course.code} - {course.name}</option>
              ))}
            </select>
          </div>
          <div>
            <label className="block text-xs font-bold text-gray-700 mb-1.5 uppercase">Select Teacher</label>
            <select
              required
              value={assignForm.teacherId}
              onChange={e => setAssignForm({ ...assignForm, teacherId: e.target.value })}
              className="w-full px-3 py-2 bg-gray-50 border border-gray-200 rounded-xl text-sm focus:outline-none focus:border-tomato-500 smooth-transition"
            >
              <option value="">-- Choose Teacher --</option>
              {teachers.filter(t => t.status === 'approved').map(t => (
                <option key={t.id} value={t.id}>{t.name} ({t.email})</option>
              ))}
            </select>
          </div>
          <button type="submit" className="tomato-btn w-full py-2.5 mt-2">Assign Teacher</button>
        </form>
      </Modal>

      {/* Modal: Direct Enroll Student */}
      <Modal isOpen={isEnrollModalOpen} onClose={() => setIsEnrollModalOpen(false)} title="Direct Enroll Student">
        <form onSubmit={handleEnrollStudent} className="space-y-4">
          <div>
            <label className="block text-xs font-bold text-gray-700 mb-1.5 uppercase">Select Course</label>
            <select
              required
              value={enrollForm.courseId}
              onChange={e => setEnrollForm({ ...enrollForm, courseId: e.target.value })}
              className="w-full px-3 py-2 bg-gray-50 border border-gray-200 rounded-xl text-sm focus:outline-none focus:border-tomato-500 smooth-transition"
            >
              <option value="">-- Choose Course --</option>
              {courses.map(course => (
                <option key={course.id} value={course.id}>{course.code} - {course.name}</option>
              ))}
            </select>
          </div>
          <div>
            <label className="block text-xs font-bold text-gray-700 mb-1.5 uppercase">Select Student</label>
            <select
              required
              value={enrollForm.studentId}
              onChange={e => setEnrollForm({ ...enrollForm, studentId: e.target.value })}
              className="w-full px-3 py-2 bg-gray-50 border border-gray-200 rounded-xl text-sm focus:outline-none focus:border-tomato-500 smooth-transition"
            >
              <option value="">-- Choose Student --</option>
              {students.filter(s => s.status === 'approved').map(s => (
                <option key={s.id} value={s.id}>{s.name} ({s.id})</option>
              ))}
            </select>
          </div>
          <button type="submit" className="tomato-btn w-full py-2.5 mt-2">Enroll Student</button>
        </form>
      </Modal>

    </div>
  );
}
