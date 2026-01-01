<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<jsp:include page="../common/header.jsp" />

<div class="container mx-auto px-4 py-8">
    <h1 class="text-3xl font-bold mb-6">Counselor Performance</h1>
    
    <c:if test="${not empty error}">
        <div class="bg-red-100 border border-red-400 text-red-700 px-4 py-3 rounded mb-4">
            ${error}
        </div>
    </c:if>
    
    <div class="bg-card rounded-lg shadow-sm border border-border overflow-hidden">
        <table class="min-w-full divide-y divide-border">
            <thead class="bg-muted">
                <tr>
                    <th class="px-6 py-3 text-left text-xs font-medium uppercase">Counselor</th>
                    <th class="px-6 py-3 text-left text-xs font-medium uppercase">Total Appointments</th>
                    <th class="px-6 py-3 text-left text-xs font-medium uppercase">Pending</th>
                    <th class="px-6 py-3 text-left text-xs font-medium uppercase">Confirmed</th>
                    <th class="px-6 py-3 text-left text-xs font-medium uppercase">Denied</th>
                    <th class="px-6 py-3 text-left text-xs font-medium uppercase">Approval Rate</th>
                </tr>
            </thead>
            <tbody class="bg-card divide-y divide-border">
                <c:forEach var="stat" items="${counselorStats}">
                    <tr class="hover:bg-muted">
                        <td class="px-6 py-4 whitespace-nowrap font-medium">${stat.counselorName}</td>
                        <td class="px-6 py-4 whitespace-nowrap">${stat.totalAppointments}</td>
                        <td class="px-6 py-4 whitespace-nowrap">${stat.pendingAppointments}</td>
                        <td class="px-6 py-4 whitespace-nowrap text-green-600">${stat.confirmedAppointments}</td>
                        <td class="px-6 py-4 whitespace-nowrap text-red-600">${stat.deniedAppointments}</td>
                        <td class="px-6 py-4 whitespace-nowrap">
                            <span class="px-2 py-1 rounded-full text-sm 
                                ${stat.approvalRate >= 80 ? 'bg-green-100 text-green-800' : 
                                  stat.approvalRate >= 50 ? 'bg-yellow-100 text-yellow-800' : 
                                  'bg-red-100 text-red-800'}">
                                ${stat.formattedApprovalRate}
                            </span>
                        </td>
                    </tr>
                </c:forEach>
                
                <c:if test="${empty counselorStats}">
                    <tr>
                        <td colspan="6" class="px-6 py-4 text-center text-muted-foreground">
                            No counselor data available
                        </td>
                    </tr>
                </c:if>
            </tbody>
        </table>
    </div>
</div>

<jsp:include page="../common/footer.jsp" />