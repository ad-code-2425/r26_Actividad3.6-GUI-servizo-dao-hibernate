package com.example.hibernate.model.util;

import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.hibernate.Transaction;

public class TransactionManager {

    private final SessionFactory sessionFactory;

    public TransactionManager(SessionFactory sessionFactory) {
        this.sessionFactory = sessionFactory;
    }

    public <R> R ejecutar(OperacionHibernate<R> operacion) {
        Transaction tx = null;
        try {
            Session session = sessionFactory.getCurrentSession();
            tx = session.beginTransaction();
            R resultado = operacion.ejecutar();
            tx.commit();
            return resultado;
        } catch (Exception e) {
            if (tx != null) tx.rollback();
            throw new RuntimeException("Error en la transacción", e);
        }
    }
}
